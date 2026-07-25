{ ... }:
{
  programs.nixvim = {
    # create groups for autocommands, make them empty so reevaluating does not lead to accidental double callbacks
    autoGroups = {
      # general group
      nixvim_general = {
        clear = true;
      };
      # spellcheck group
      prose_spellcheck = {
        clear = true;
      };
    };
    autoCmd = [
      # quickly highlight yanked text
      {
        event = "TextYankPost";
        pattern = "*";
        group = "nixvim_general";
        desc = "Highlight yanked text";

        callback.__raw = ''
          function()
            vim.highlight.on_yank({
              higroup = "IncSearch",
              timeout = 200,
            })
          end
        '';
      }

      # restore last cursor position
      {
        event = "BufReadPost";
        pattern = "*";
        group = "nixvim_general";
        desc = "Restore cursor to last known position";

        callback.__raw = ''
          function(args)
            if vim.api.nvim_get_current_buf() ~= args.buf then
              return
            end

            -- '"' contains the last cursor position
            local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
            local line_count = vim.api.nvim_buf_line_count(args.buf)

            -- if last position is within bounds set cursor to it
            if mark[1] > 0 and mark[1] <= line_count then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end
        '';
      }

      # create missing directories on save
      {
        event = "BufWritePre";
        pattern = "*";
        group = "nixvim_general";
        desc = "Create missing parent directories before saving";

        callback.__raw = ''
          function(args)
            local file = vim.api.nvim_buf_get_name(args.buf)

            if file == "" or file:match("^%a[%w+.-]*://") then
              return
            end

            local parent = vim.fn.fnamemodify(file, ":p:h")

            if vim.fn.isdirectory(parent) == 0 then
              vim.fn.mkdir(parent, "p")
            end
          end
        '';
      }

      # close modal windows with q
      {
        event = "FileType";
        pattern = [
          "checkhealth"
          "help"
          "lspinfo"
          "man"
          "qf"
          "snacks_win"
        ];
        group = "nixvim_general";
        desc = "Close utility buffers with q";

        callback.__raw = ''
          function(args)
            vim.bo[args.buf].buflisted = false

            vim.keymap.set("n", "q", function()
              pcall(vim.api.nvim_buf_delete, args.buf, {
                force = true,
              })
            end, {
              buffer = args.buf,
              silent = true,
              desc = "Close utility buffer",
            })
          end
        '';
      }

      # spellcheck autocmd for german and english
      {
        event = "FileType";
        pattern = [
          "markdown"
          "markdown.mdx"
          "text"
          "gitcommit"
        ];

        group = "prose_spellcheck";
        desc = "Enable spellcheck in prose buffers";

        command = "setlocal spell spelllang=en_us,de_de";
      }
    ];
  };
}
