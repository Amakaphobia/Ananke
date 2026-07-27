{ config, lib, ... }:
let
  colors = config.lib.stylix.colors.withHashtag;
  cfg = config.ananke.cli.nixvim.enable;
  # Create one transparent Lualine theme mode.
  # "NONE" means that Lualine does not paint a background.
  transparentMode = accent: {
    a = {
      fg = accent;
      bg = "NONE";
      gui = "bold";
    };

    b = {
      fg = accent;
      bg = "NONE";
    };

    c = {
      fg = colors.base05;
      bg = "NONE";
    };
  };
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins.lualine = {
      enable = true;
      settings = {
        options = {
          # Display one statusline for the entire Neovim instance.
          globalstatus = true;

          # Set the background to transparent
          theme = {
            normal = transparentMode colors.base0D;
            insert = transparentMode colors.base0B;
            visual = transparentMode colors.base0E;
            replace = transparentMode colors.base08;
            command = transparentMode colors.base0A;
            terminal = transparentMode colors.base0C;

            inactive = {
              a = {
                fg = colors.base03;
                bg = "NONE";
              };

              b = {
                fg = colors.base03;
                bg = "NONE";
              };

              c = {
                fg = colors.base03;
                bg = "NONE";
              };
            };
          };

          # Remove Powerline-style arrows and dividers.
          section_separators = "";
          component_separators = "";
        };
        sections = {
          # Leftmost: current editor mode.
          lualine_a = [
            "mode"
          ];

          # Git and diagnostic state.
          lualine_b = [
            "branch"

            {
              __unkeyed-1 = "diff";

              symbols = {
                added = "+";
                modified = "~";
                removed = "-";
              };
            }

            {
              __unkeyed-1 = "diagnostics";

              sources = [
                "nvim_diagnostic"
              ];

              symbols = {
                error = "E:";
                warn = "W:";
                info = "I:";
                hint = "H:";
              };
            }
          ];

          # Project and current file.
          lualine_c = [
            {
              __unkeyed-1.__raw = ''
                function()
                  local root = vim.fs.root(0, {
                    ".git",
                    "flake.nix",
                    "package.json",
                    "Cargo.toml",
                    "go.mod",
                    "pyproject.toml",
                  })

                  root = root or vim.fn.getcwd()

                  return vim.fn.fnamemodify(root, ":t")
                end
              '';

              icon = "󰉋";
            }

            {
              __unkeyed-1 = "filename";

              # Display the path relative to the working directory.
              path = 1;

              file_status = true;
              newfile_status = true;

              symbols = {
                modified = " [+]";
                readonly = " [readonly]";
                unnamed = "[No Name]";
                newfile = "[New]";
              };
            }
          ];

          # Right side.
          lualine_x = [
            "filetype"
          ];

          lualine_y = [
            "progress"
          ];

          lualine_z = [
            "location"

            {
              __unkeyed-1 = "datetime";
              style = "%H:%M";
            }
          ];
        };
      };
    };
  };
}
