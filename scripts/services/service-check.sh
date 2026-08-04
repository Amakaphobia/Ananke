#!/usr/bin/env bash
set -euo pipefail

# Persistent state belonging to this user-level program.
state_dir="${XDG_STATE_HOME:-"$HOME/.local/state"}/ananke-health"
cursor_file="$state_dir/journal-error.cursor"

mkdir -p "$state_dir"

# returns the last logged cursor in journalctl
get_latest_cursor() {
  journalctl \
    --quiet \
    --no-pager \
    --lines=1 \
    --show-cursor |
    sed -n 's/^-- cursor: //p'
}

# saves the latest cursor into cursorfile(defined above)
initialize_cursor() {
  local cursor
  cursor="$(get_latest_cursor)"

  # if cursor has nonzero length
  if [[ -n "$cursor" ]]; then
    # write to cursor file
    printf '%s\n' "$cursor" >"$cursor_file"
  fi
}

# ! -s -> if file has size 0
if [[ ! -s "$cursor_file" ]]; then
  initialize_cursor
  printf 'Initialized journal cursor; existing errors were ignored.\n'
  exit 0
fi

# read cursor file into variable
previous_cursor="$(<"$cursor_file")"

# disable set -e,
# read the journal record if jounalctl works as expected
# enable set -e
set +e
result="$(
  journalctl \
    --quiet \
    --no-pager \
    --after-cursor="$previous_cursor" \
    --priority=err \
    --output=short-iso \
    --show-cursor
)"
journal_status=$?
set -e

# if the journal does not work as expected reinitialize cursor file
if ((journal_status != 0)); then
  printf 'Stored journal cursor is invalid; resetting it.\n'
  initialize_cursor
  exit 0
fi

# seperate the new cursor from the messages
new_cursor="$(sed -n 's/^-- cursor: //p' <<<"$result")"
messages="$(sed '/^-- cursor: /d' <<<"$result")"

# if messages is null nothing new happened
if [[ -z "$messages" ]]; then
  if [[ -t 1 ]]; then
    printf "no new messages\n"
  fi
  exit 0
fi

# if new cursor is null something broke
if [[ -z "$new_cursor" ]]; then
  printf 'journalctl returned messages without a cursor.\n' >&2
  exit 1
fi

# count lines in messages (1 line -> 1 msg)
line_count="$(awk 'END { print NR }' <<<"$messages")"

# show entries if evoked from a terminal
if [[ -t 1 ]]; then
  printf '%s\n' "$messages"
fi

# update cursor file
printf '%s\n' "$new_cursor" >"$cursor_file"

# copy command for new journal entries
clipboard_text="journalctl -p err -n $line_count"

# try to send notification annotate that default action is to put clipboard_text into clipboard
set +e
selected_action="$(
  notify-send \
    --app-name="Ananke Health" \
    --urgency=normal \
    --expire-time=30000 \
    --action=default="Copy journal command" \
    "New journal errors" \
    "$line_count new error entries. Click to copy the inspection command."
)"
# record notify-sends exit code
notify_status=$?
set -e

# if default action was choses put command into clipboard
if [[ "$selected_action" == "default" ]]; then
  printf '%s\n' "$clipboard_text" | wl-copy
# else if notify-sends exit code was != 0 log it
elif ((notify_status != 0)); then
  printf 'Could not deliver the desktop notification.\n'
fi
