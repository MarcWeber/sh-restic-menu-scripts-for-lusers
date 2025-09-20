#!/bin/bash

# Consolidated Restic Operations Script
# VERSION: restic_0.16.2

BACKUP_DIR="E:/backup_von_externer_ssd"
SOURCE_DIRS=(
  "DIR1" 
  "DIR2"
)
PASSWORD_ARGS=()
# PASSWORD_ARGS=(--password-file password.txt)
PASSWORD_REMINDER=""

menu() {
  echo "Select an option:"
  echo "1. Backup files"
  echo "2. Init backup directory"
  echo "3. Check repository quick"
  echo "4. Check repository all"
  echo "5. List snapshots"
  echo "6. Unlock (or reboot for safety)"
  echo "7. Exit"
  echo "8. Find files in backup"
  echo "9. grafische Wiederherstellung"
  echo "0. Anleitung"
  read -p "Enter your choice (1-8): " choice


  [ -z "$PASSWORD_REMINDER" ] || echo "$PASSWORD_REMINDER"

  case $choice in
    1) backup ;;
    2) init_backup_dir ;;
    3) check_quick ;;
    4) check_all ;;
    5) list_snapshots ;;
    6) unlock ;;
    7) exit 0 ;;
    8) list_snapshots_find_files ;;
    9) ui_restore ;;
    *) echo "Invalid choice."; pause; exit 1 ;;
  esac
}


backup() {
  restic backup "${PASSWORD_ARGS[@]}" --exclude "O:/\$RECYCLE.BIN" -r "$BACKUP_DIR" "${SOURCE_DIRS[@]}"
  pause
}

init_backup_dir() {
  restic init "${PASSWORD_ARGS[@]}" -r "$BACKUP_DIR"
  pause
}

check_quick() {
  restic check "${PASSWORD_ARGS[@]}" -r "$BACKUP_DIR"
  pause
}

check_all() {
  restic check "${PASSWORD_ARGS[@]}" -r "$BACKUP_DIR" --read-data
  pause
}

list_snapshots() {
  restic "${PASSWORD_ARGS[@]}" -r "$BACKUP_DIR" snapshots
  pause
}

list_snapshots_find_files() {
  echo "List snapshots, select with mouse and press Enter"
  restic "${PASSWORD_ARGS[@]}" -r "$BACKUP_DIR" snapshots
  read -p "Snapshot ID: " SNAPSHOT
  read -p "Search for (e.g., /C/Users/NAME): " FIND
  restic "${PASSWORD_ARGS[@]}" -r "$BACKUP_DIR" ls "$SNAPSHOT" | grep "$FIND"
  pause
}

ui_restore() {
  echo siehe https://github.com/emuell/restic-browser
  pause
}

unlock() {
  restic "${PASSWORD_ARGS[@]}" -r "$BACKUP_DIR" unlock
  pause
}


guide() {
  cat << EOF
open the bat file and  define SOURCE_DIRS BACKUP_DIR PASSWORD_REMINDER or PASSWORD_ARGS
then use option 2 initialize backup target directory
for each backup you want to do run option 1 create new backup snapshot
EOF
  pause
}

pause() {
  read -p "Press Enter to continue..."
}

menu
