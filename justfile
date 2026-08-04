#!/usr/bin/env -S just --justfile

alias cf := checkformat
alias cl := checklint
alias cq := checkquick
alias c := check

default_system := arch() + "-linux"

# Interactive recipe picker
[default]
[private]
default:
    #!/usr/bin/env bash

    selection="$(
      just --list \
        --list-heading '' \
        --list-prefix '' \
        --no-aliases |
      # /^[[:space:]]*$/ { next } skip empty or blank lines 
      # /^[[:space:]]*\[/ { next } skip lines that beginn with <whitespace?>[ 
      # sub(/^[[:space:]]+/, "")  substitute whitespace at the beginning of the line with ""
      awk '
        /^[[:space:]]*$/ { next }
        /^[[:space:]]*\[/ { next }
        {
          sub(/^[[:space:]]+/, "")
          print
        }
      ' |
      fzf \
        --height=70% \
        --layout=reverse \
        --border \
        --prompt='just> ' \
        --header='Enter: run • Esc: cancel' \
        --preview='just --color always --show {1}' \
        --preview-window='right:55%:wrap' \
        || true
    )"

    [[ -z "$selection" ]] && exit 0

    recipe="${selection%% *}"
    just "$recipe"

# Format the repository and justfile
[group("maintenance")]
format:
    @nix fmt
    @just --fmt

# Check Nix formatting
[arg("system", long="system", short="s")]
[group("checks")]
checkformat system=default_system:
    @nix build \
      ".#checks.{{ system }}.formatting" \
      --no-link \
      --print-build-logs

# Run Statix and Deadnix
[arg("system", long="system", short="s")]
[group("checks")]
checklint system=default_system:
    @nix build \
      ".#checks.{{ system }}.statix" \
      --no-link \
      --print-build-logs
    @nix --no-warn-dirty build \
      ".#checks.{{ system }}.deadnix" \
      --no-link \
      --print-build-logs

# Check tracked files, formatting, Statix, and Deadnix
[arg("system", long="system", short="s")]
[group("checks")]
checkquick system=default_system:
    @./scripts/checks/quickcheck.sh "{{ system }}"

# Run every flake check, including the complete NixOS system build
[group("checks")]
check:
    @nix flake check --print-build-logs

# Show flake outputs
[group("information")]
show:
    @nix flake show

# Build a configuration without activating it
[arg("host", long="host")]
[arg("path", long="path")]
[group("system")]
build path="." host="": checkquick
    @nh os build {{ quote(if host == "" { path } else { path + "#" + host }) }} \
      -- --option warn-dirty false

# Temporarily activate a configuration until reboot
[arg("host", long="host")]
[arg("path", long="path")]
[group("system")]
test path="." host="": checkquick
    @nh os test {{ quote(if host == "" { path } else { path + "#" + host }) }} \
    -- --option warn-dirty false

# Set a configuration as the next boot default without activating it
[arg("host", long="host")]
[arg("path", long="path")]
[group("system")]
boot path="." host="": checkquick
    @nh os boot {{ quote(if host == "" { path } else { path + "#" + host }) }} \
    -- --option warn-dirty false

# Activate a configuration and set it as the boot default
[arg("host", long="host")]
[arg("path", long="path")]
[group("system")]
switch path="." host="": checkquick
    @nh os switch {{ quote(if host == "" { path } else { path + "#" + host }) }} \
    -- --option warn-dirty false
