#! /usr/bin/env bash

set -euo pipefail

username=
homedir=
action=
backupPath=

declare -A directories
# User data
directories["Documents"]="Documents"
directories["Downloads"]="Downloads"
directories["Music"]="Music"
directories["Pictures"]="Pictures"
directories["Videos"]="Videos"
# Program state
directories["gnupg"]=".gnupg"
directories["sops"]=".config/sops"
directories["firefox"]=".config/mozilla/firefox"
directories["thunderbird"]=".thunderbird"
directories["zoxide"]=".local/share/zoxide"
directories["gh"]=".config/gh"

prepare() {

  # ask for username

  read -r -p "Please enter username: " username

  if [[ -z "$username" ]]; then
    echo "Username can not be empty"
    return 1
  fi

  # setting homedir based on username

  if getent passwd "$username" >/dev/null; then
    homedir=$(getent passwd "$username" | cut --delimiter ":" --fields 6)
  else
    printf "User %s does not exist, exiting\n" "$username"
    return 1
  fi

  if [[ -d "$homedir" ]]; then
    printf "set source to %s\n" "$homedir"
  else
    printf "%s is not a directory exiting\n" "$homedir"
    return 1
  fi

  # ask for backup location

  backupPath=
  read -r -p "Please enter backup path: " backupPath

  if [[ -d "$backupPath" ]]; then
    printf "set target to %s\n" "$backupPath"
  else
    printf "%s is not a directory exiting\n" "$backupPath"
    return 1
  fi

  # ask for action

  read -r -p "Do you want to [r]estore, [b]ackup or [E]xit" action
  if [[ "$action" != "r" && "$action" != "b" ]]; then
    echo "exiting"
    exit 0
  fi

  echo "done preparing"
}

doBackup() {
  local failed=0
  # create subfolder for backups

  if [[ ! -w "$backupPath" ]]; then
    printf "%s is not writeable, exiting\n" "$backupPath"
    return 1
  fi

  local timeStamp=
  timeStamp=$(date +%Y%m%d)

  local target="$backupPath/$timeStamp"

  if ! mkdir "$target"; then
    printf "Could not create folder:\n%s\n" "$target"
    return 1
  fi
  printf "Backupfolder created at:\n%s\n" "$target"

  for folder in "${directories[@]}"; do
    if ! copyFromPath "$homedir" "$folder" "$target"; then
      ((failed += 1))
      printf ">>>>failed<<<< at: %s\n" "$folder"
    else
      printf "%s at: %s\n" "----success----" "$folder"
    fi
  done

  printf "\nflushing filesystem, this may take a long while\n\n"
  sync -f "$target"
  echo "done flushing"

  return $failed
}

doRestore() {
  local failed=0

  local timeStamp=
  # ask for specific backup
  find "$backupPath" -mindepth 1 -maxdepth 1 -type d -printf '%f\n'
  read -r -p "Please enter a backup: " timeStamp

  local source="$backupPath/$timeStamp"

  if [[ ! -d "$source" ]]; then
    printf "%s is not a directory\n" "$source"
    return 1
  fi

  for folder in "${directories[@]}"; do
    if ! copyFromPath "$source" "$folder" "$homedir"; then
      ((failed += 1))
      printf ">>>>failed<<<< at: %s\n" "$folder"
    else
      printf "%s at: %s\n" "----success----" "$folder"
    fi
  done

  return $failed
}

copyFromPath() {
  local source="$1"
  local subpath="$2"
  local destination="$3"

  if [[ ! -e "$source/$subpath" ]]; then
    printf 'Source does not exist: %s\n' "$source/$subpath"
    return 1
  fi

  if ! rsync -aHAXR -- "$source/./$subpath" "$destination/"; then
    printf 'Failed to copy: %s\n' "$source"
    return 1
  fi
}

doAction() {
  case "$action" in
  "r")
    doRestore
    ;;
  "b")
    doBackup
    ;;
  esac
}

main() {
  prepare
  echo "starting action"
  doAction
  echo "action done"
}

echo "hello world"
main
echo "you welcome"
