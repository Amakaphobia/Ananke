{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.home.shell.addons;
  helper = import (paths.lib + "/helper.nix") { inherit lib; };

  timerCommand = ''
    ms="$ANANKE_CMD_DURATION"
    if (( ms < 1000 )); then
        printf '%dms' "$ms"

    elif (( ms < 60000 )); then
        printf '%.1fs' "$(( ms / 1000.0 ))"

    else
        minutes=$(( ms / 60000 ))
        seconds=$(( (ms % 60000) / 1000 ))

        printf '%dm%02ds' "$minutes" "$seconds"
    fi
  '';
in
{

  options.ananke.home.shell.addons.starship = {
    enable = helper.mkDefaultOnOption "starship";
  };

  config = lib.mkIf (cfg.enable && cfg.starship.enable) {
    programs.starship = {
      enable = true;

      settings = {
        add_newline = false;
        command_timeout = 500;

        format = ''
          [┌](bold fg:purple) $os[ ─ ](bold fg:purple)$username$hostname$nix_shell $fill''${custom.command_success}''${custom.command_failure}[ ┘ ](bold fg:purple)
          [│](bold fg:purple) $directory $git_branch$git_status
          [└─\(](bold fg:purple)[ $time ](bold fg:blue)[\)](bold fg:purple)$character 
        '';
        fill = {
          symbol = "─";
          style = "bold fg:purple";
        };

        # --- Main Modules ---
        os = {
          disabled = false;
          format = "[$symbol]($style)";
          style = "bold fg:cyan ";
          symbols = {
            NixOS = "";
          };
        };
        username = {
          disabled = false;
          format = "[ $user]($style)";
          show_always = true;
          style_root = "fg:bright-red ";
          style_user = "fg:purple";
        };

        hostname = {
          disabled = false;
          format = "[@$ssh_symbol$hostname: ]($style)";
          style = "fg:purple";
          ssh_only = false;
          ssh_symbol = "󰒋 ";
        };

        directory = {
          disabled = false;
          format = "[$path]($style)[$read_only]($read_only_style)";
          truncation_length = 9;
          truncate_to_repo = true;
          style = "fg:green";
        };

        git_branch = {
          disabled = false;
          symbol = " ";
          format = "[$symbol$branch]($style)";
          style = "fg:yellow";
        };

        git_status = {
          disabled = false;
          format = " ([$all_status$ahead_behind]($style))";
          style = "fg:yellow";

          conflicted = "=";
          ahead = "⇡";
          behind = "⇣";
          diverged = "⇕";
          untracked = "?";
          stashed = "$";
          modified = "!";
          staged = "+";
          renamed = "»";
          deleted = "x";
        };

        nix_shell = {
          disabled = false;
          symbol = "nix";
          format = "[$symbol$state(\\($name\\))]($style)";
          style = "bold blue";
        };

        character = {
          disabled = false;
          format = "$symbol";
          success_symbol = "[-->](purple)";
          error_symbol = "[ :](bold red)";
        };

        time = {
          disabled = false;
          format = "[$time]($style)";
          style = "bold blue";
        };

        # display time colored based on exit state
        custom = {
          command_success = {
            when = ''[ -n "$ANANKE_CMD_STATUS" ] && [ "$ANANKE_CMD_STATUS" -eq 0 ]'';
            command = timerCommand;

            format = "[ 󰅐 $output]($style)";
            style = "fg:green";
          };

          command_failure = {
            when = ''[ -n "$ANANKE_CMD_STATUS" ] && [ "$ANANKE_CMD_STATUS" -ne 0 ]'';
            command = timerCommand;

            format = "[ 󱡦 $output]($style)";
            style = "fg:red";
          };
        };
      };
    };
  };
}
