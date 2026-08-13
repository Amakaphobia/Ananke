#!/usr/bin/env bash

selected="$(
  fd \
    --type directory \
    --min-depth 1 \
    --absolute-path \
    . "$HOME" |
    fzf \
      --height=70% \
      --layout=reverse \
      --border \
      --prompt="tmux> "
)"

# early exit, if nothing was selected
[[ -z "$selected" ]] && exit 0

# remove trailing /
selected="${selected%/}"

# Get the last directoryname, replace everything that is not a letter number dash or underscore with "_"
# use as session name
session_name="$(
  printf '%s' "${selected#"$HOME/"}" |
    tr -cs '[:alnum:]_-' '_'
)"

# prepend a "=" to session name, to force exact matching on the name
target="=$session_name"

# If the project already has a session, don't recreate it.
if tmux has-session -t "$target" 2>/dev/null; then
  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$target"
  else
    tmux attach-session -t "$target"
  fi
  # were done here. Exiting
  exit 0
fi

#
# Create the session
#

# Window 1: Shell
tmux new-session \
  -d \
  -s "$session_name" \
  -c "$selected" \
  -n "shell"

start_window="$session_name:shell"

# Window 2: editor
tmux new-window \
  -d \
  -t "$session_name:" \
  -c "$selected" \
  -n "editor"

tmux send-keys \
  -t "$session_name:editor" \
  "clear && nvim ." Enter

# maybe Window 3: Git

if git -C "$selected" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  tmux new-window \
    -d \
    -t "$session_name:" \
    -c "$selected" \
    -n "git"

  tmux send-keys \
    -t "$session_name:git" \
    "clear && " \
    "git status --short && " \
    "echo '' && " \
    "git log --oneline --decorate --graph --max-count 10" \
    Enter

  start_window="$session_name:git"
fi

tmux select-window -t "$start_window"

# if tmux is running dont nest but switch, if tmux is not running reattach normally
if [[ -n "${TMUX:-}" ]]; then
  exec tmux switch-client -t "$target"
else
  exec tmux attach-session -t "$target"
fi
