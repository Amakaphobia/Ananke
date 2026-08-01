{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim = {
      # treat mdx files as markdown with mdx syntax
      filetype.extension.mdx = "markdown.mdx";

      plugins = {
        # preview in browser
        markdown-preview = {
          enable = true;

          # set filetypes accepted for preview
          settings.filetypes = [
            "markdown"
            "markdown.mdx"
          ];
        };

        # markdown presentation inside nixvim
        render-markdown = {
          enable = true;

          # set filetypes accepted for rendering
          settings = {
            file_types = [
              "markdown"
              "markdown.mdx"
            ];

            code = {
              # keep gutter cleaner
              sign = false;
              # render as distinct block
              width = "block";
              # pad codeblocks a little
              right_pad = 1;
            };

            heading = {
              # keep gutter cleaner
              sign = false;
              # do not assign rendered symbols to headings
              icons = [ ];
            };

            #do not render checkboxes
            checkbox.enabled = false;

          };
        };
      };

      # add autocommand to add keybinds for markdown actions only when markdown buffers are opened
      autoCmd = [
        {
          # fire on new buffer of markdown type
          event = "FileType";
          pattern = [
            "markdown"
            "markdown.mdx"
          ];

          callback.__raw = ''
            function(args)
              local map = function(key, command, description)
                  vim.keymap.set("n", key, command, {
                    buffer = args.buf,
                    silent = true,
                    desc = description,
                  })
                end

                map(
                  "<leader>cp",
                  "<cmd>MarkdownPreviewToggle<cr>",
                  "Markdown preview"
                )

                map(
                  "<leader>um",
                  "<cmd>RenderMarkdown toggle<cr>",
                  "Toggle rendered Markdown"
                )
              end
          '';
        }
      ];
    };
  };
}
