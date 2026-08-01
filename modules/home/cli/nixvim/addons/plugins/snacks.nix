{ config, lib, ... }:
let
  cfg = config.ananke.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim = {
      plugins.snacks = {
        enable = true;

        settings = {

          explorer.enabled = true;

          picker = {
            enabled = true;

            sources.explorer = {
              # Show ignored files too
              ignored = true;

              # Close picker after opening a file
              jump.close = true;
            };
          };

          # indentation guides
          indent.enabled = true;

          # scope detection
          scope.enabled = true;

          # big file handling
          bigfile.enabled = true;
          # load file content faster
          quickfile.enabled = true;

          # highlight other occurrences of word under cursor
          words = {
            enabled = true;

            # turn it off for nix files, because it shits out 50 loglines per minute full of errors
            filter = config.lib.nixvim.mkRaw ''
              function(buf)
                return vim.bo[buf].filetype ~= "nix"
                  and vim.g.snacks_words ~= false
                  and vim.b[buf].snacks_words ~= false
              end
            '';
          };

          # notifications
          notifier = {
            enabled = true;
            timeout = 3000;
            style = "compact";
          };
        };
      };

      keymaps = [
        # files
        {
          mode = "n";
          key = "<leader>e";
          action.__raw = "function() Snacks.explorer() end";
          options.desc = "File explorer";
        }
        {
          mode = "n";
          key = "<leader>ff";
          action.__raw = "function() Snacks.picker.files() end";
          options.desc = "Find files";
        }
        {
          mode = "n";
          key = "<leader>fg";
          action.__raw = "function() Snacks.picker.grep() end";
          options.desc = "Grep files";
        }
        # buffer
        {
          mode = "n";
          key = "<leader>bb";
          action.__raw = "function() Snacks.picker.buffers() end";
          options.desc = "Open buffer list";
        }
        {
          mode = "n";
          key = "<leader>bd";
          action.__raw = "function() Snacks.bufdelete() end";
          options.desc = "Delete buffer";
        }
        # jump through word under cursor
        {
          mode = "n";
          key = "]r";
          action.__raw = ''
            function()
              Snacks.words.jump(vim.v.count1)
            end
          '';
          options.desc = "Next reference";
        }
        {
          mode = "n";
          key = "[r";
          action.__raw = ''
            function()
              Snacks.words.jump(-vim.v.count1)
            end
          '';
          options.desc = "Previous reference";
        }
        # notifications
        {
          mode = "n";
          key = "<leader>nh";
          action.__raw = "function() Snacks.notifier.show_history() end";
          options.desc = "Notification history";
        }
        # floating terminal
        {
          mode = [
            "n"
            "t"
          ];
          key = "<leader>tt";
          action.__raw = ''
            function()
              Snacks.terminal.toggle(nil, {
                win = {
                  position = "float",
                  border = "rounded",
                },
              })
            end
          '';
          options.desc = "Toggle floating terminal";
        }
      ];
    };
  };
}
