{ config, lib, ... }:
let
  cfg = config.ananke.profiles.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim = {
      plugins.snacks = {
        enable = true;

        settings = {

          explorer.enabled = true;
          input.enabled = true;

          picker = {
            enabled = true;

            sources.explorer = {
              # Show ignored files too
              ignored = true;

              # Close picker after opening a file
              jump.close = true;

              # Refresh filesystem and git state whenever explorer opens
              on_show = config.lib.nixvim.mkRaw ''
                function(picker)
                  require("snacks.explorer.actions").actions.explorer_update(picker)
                end
              '';
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

            # TODO: 090820206 remove filter block when upstream is fixed

            # nixd logs repeated documentHighlight errors for some cursor positions
            # keep filer until nixd#687 is fixed.
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
        # search
        {
          mode = "n";
          key = "<leader>sd";
          action.__raw = "function() Snacks.picker.diagnostics() end";
          options.desc = "Search diagnostics";
        }
        {
          mode = "n";
          key = "<leader>st";
          action.__raw = "function() Snacks.picker.todo_comments() end";
          options.desc = "Search todos";
        }
        {
          mode = "n";
          key = "<leader>sk";
          action.__raw = "function() Snacks.picker.keymaps() end";
          options.desc = "Search keymaps";
        }
        {
          mode = "n";
          key = "<leader>sh";
          action.__raw = "function() Snacks.picker.help() end";
          options.desc = "Search help";
        }
        # git
        {
          mode = "n";
          key = "<leader>gs";
          action.__raw = "function() Snacks.picker.git_status() end";
          options.desc = "Git status";
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
