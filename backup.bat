@echo off
REM Consolidated Restic Operations Batch File
REM VERSION: restic_0.16.2_windows_amd64.exe

REM SET SOURCE_DIRS=C:\1 "C:\2 0"
SET SOURCE_DIRS=C:\users
SET BACKUP_DIR="O:\backup_dateien_willi"
REM SET PASSWORD_ARGS=
SET PASSWORD_ARGS=--password-file password-willi.txt
SET PASSWORD_REMINDER=""

:menu
@echo on
goto menu_de

:menu_de
echo Select an option:
echo 1. MACHE BACKUP SNAPSHOT
echo O. MACHE BACKUP SNAPSHOT dann runterfahren
echo 2. Backup Zielverzeichnis initialisieren
echo 3. Prüfe Repo schnell
echo 4. Prüfe Repo schnell alle Inhalte
echo 5. Mache Liste der Snapshots
echo 6. Unlock (oder neu boote neu was sicherer ist nutzen wenn DU Restic abgebrochen hast) 
echo 7. Exit
echo 8. Finde Dateien in Backup (snapshots -> ls)
echo 9. grafische Wiederherstellung
echo 0. ANLEITUNG
set /p choice=Enter your choice (1-7):
goto choice_switch

:menu_en
cls
echo Select an option:
echo 1. BACKUP create new snapshot
echo 2. init backup directory
echo 3. Check repository quick
echo 4. Check repository all
echo 5. List snapshots
echo 6. Unlock (oder neu booten was sicherer ist)
echo 7. Exit
echo 8. find files in backup (snapshots -> ls)
echo 9. UI based restore
echo 0. HOWTO
set /p choice=Enter your choice (1-7): 
goto choice_switch


:choice_switch

echo %PASSWORD_REMINDER%

if "%choice%"=="1" goto backup
if "%choice%"=="O" goto backup_shutdown
if "%choice%"=="2" goto init_backup_dir
if "%choice%"=="3" goto check_quick
if "%choice%"=="4" goto check_all
if "%choice%"=="5" goto list_snapshots
if "%choice%"=="6" goto unlock
if "%choice%"=="7" goto end
if "%choice%"=="8" goto list_snapshots_find_files
if "%choice%"=="9" goto ui_restore
if "%choice%"=="0" goto guide

echo Invalid choice. Please try again.
pause
goto end

:backup
restic.exe backup %PASSWORD_ARGS% --exclude O:\$RECYCLE.BIN -r %BACKUP_DIR% %SOURCE_DIRS%
pause
goto end

:backup_shutdown
restic.exe backup %PASSWORD_ARGS% --exclude O:\$RECYCLE.BIN -r %BACKUP_DIR% %SOURCE_DIRS%
shutdown /s /f /t 0
goto end

:init_backup_dir
echo Passwort ist %PASSWORD%
restic.exe init %PASSWORD_ARGS% -r %BACKUP_DIR%
pause
goto end

:check_quick
restic.exe check %PASSWORD_ARGS% -r %BACKUP_DIR%
pause
goto end

:check_all
echo Passwort ist %PASSWORD%
restic.exe check %PASSWORD_ARGS% -r %BACKUP_DIR% --read-data
pause
goto end

:list_snapshots
restic.exe -r %PASSWORD_ARGS% %BACKUP_DIR%  snapshots
pause
goto end

:unlock
echo Passwort ist %PASSWORD%
restic.exe -r %PASSWORD_ARGS% %BACKUP_DIR%  unlock
pause
goto end

:list_snapshots_find_files
echo "List Snapshots, dann mit Maus anklicken und Enter zum kopieren"
restic.exe -r %PASSWORD_ARGS% %BACKUP_DIR% snapshots

echo "Liste Snapshots, dann mit Maus anklicken und Enter zum kopieren"
set /p SNAPSHOT=Snapshot ID:
set /p FIND=Wonach suchen ? Z.b /C/Users/NAME
restic.exe %PASSWORD_ARGS% -r %BACKUP_DIR% ls %SNAPSHOT% | FIND %FIND%
pause
goto end

:ui_restore
echo siehe https://github.com/emuell/restic-browser
goto end

:guide
echo open the bat file and  define SOURCE_DIRS BACKUP_DIR PASSWORD_REMINDER or PASSWORD_ARGS
echo then use option 2 initialize backup target directory
echo for each backup you want to do run option 1 create new backup snapshot
goto end

:end
echo Exiting...
pause
