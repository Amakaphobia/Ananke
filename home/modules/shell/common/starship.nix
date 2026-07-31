{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.shell.addons;
  helper = import (paths.lib + "/helper.nix") { inherit lib; };
in
{

  options.ananke.shell.addons.starship = {
    enable = helper.mkDefaultOnOption "starship";
  };

  config = lib.mkIf (cfg.enable && cfg.starship.enable) {
    programs.starship = {
      enable = true;

      settings = {
        add_newline = false;
        command_timeout = 500;

        format = ''
          $os $username$hostname $nix_shell
          $directory $git_branch$git_status
          $character 
        '';
        fill.symbol = " ";

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
          format = "[$user]($style)";
          show_always = true;
          style_root = "fg:bright-red ";
          style_user = "fg:purple";
        };

        hostname = {
          disabled = false;
          format = "[@$ssh_symbol$hostname:]($style)";
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
          symbol = "nix ";
          format = "[$symbol$state(\\($name\\))]($style)";
          style = "bold blue";
        };

        character = {
          disabled = false;
          format = "$symbol";
          success_symbol = "[](bold green)";
          error_symbol = "[](bold red)";
        };
      };
    };
  };
}
