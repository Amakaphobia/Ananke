{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.keymaps = [

      # ####
      # expected default behaviour
      # ####

      # clear search results with ESC

      {
        mode = "n";
        key = "<ESC>";
        action = "<CMD>nohl<CR>";
        options.desc = "clear search";
      }

      # keep selection after indenting in visual mode

      {
        mode = "v";
        key = "<";
        action = "<gv";
        options.desc = "Indent left";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options.desc = "Indent right";
      }

      # moving lines

      {
        mode = "v";
        key = "<A-j>";
        action = ":m '>+1<cr>gv=gv";
        options.desc = "Move selection down";
      }
      {
        mode = "v";
        key = "<A-k>";
        action = ":m '<-2<cr>gv=gv";
        options.desc = "Move selection up";
      }

      # easier navigation through wrapped lines
      {
        mode = [
          "n"
          "x"
        ];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          desc = "Down";
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          desc = "Up";
          expr = true;
          silent = true;
        };
      }

      # ####
      # window control
      # ####

      # sizing

      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options.desc = "Increase window height";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options.desc = "Decrease window height";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options.desc = "Decrease window width";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options.desc = "Increase window width";
      }
      # Splitting

      {
        mode = "n";
        key = "<leader>wv";
        action = "<C-w>v";
        options.desc = "Split window vertically";
      }
      {
        mode = "n";
        key = "<leader>ws";
        action = "<C-w>s";
        options.desc = "Split window horizontally";
      }

      # split control

      {
        mode = "n";
        key = "<leader>we";
        action = "<C-w>=";
        options.desc = "Equalize window size";
      }
      {
        mode = "n";
        key = "<leader>wx";
        action = "<cmd>close<CR>";
        options.desc = "Close current window";
      }

      # focus control

      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w><C-h>";
        options.desc = "Move focus to the left split";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w><C-j>";
        options.desc = "Move focus to the lower split";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w><C-k>";
        options.desc = "Move focus to the upper split";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w><C-l>";
        options.desc = "Move focus to the right split";
      }

      # ####
      # Buffers
      # ####

      {
        mode = "n";
        key = "<leader>bh";
        action = "<cmd>bprevious<cr>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<leader>bl";
        action = "<cmd>bnext<cr>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<leader><TAB>";
        action = "<CMD>b#<CR>";
        options.desc = "Last active buffer";
      }

      # ####
      # Diagnostics
      # ####

      {
        mode = "n";
        key = "]d";
        action.__raw = ''
          function()
            vim.diagnostic.jump({ count = 1, float = true })
          end
        '';
        options.desc = "Next diagnostic";
      }
      {
        mode = "n";
        key = "[d";
        action.__raw = ''
          function()
            vim.diagnostic.jump({ count = -1, float = true })
          end
        '';
        options.desc = "Previous diagnostic";
      }
      {
        mode = "n";
        key = "<leader>cd";
        action.__raw = "vim.diagnostic.open_float";
        options.desc = "Line diagnostic";
      }
      # make spellcheck keybinds available in which key
      {
        mode = "n";
        key = "]s";
        action = "]s";
        options = {
          desc = "Next misspelled word";
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "[s";
        action = "[s";
        options = {
          desc = "Previous misspelled word";
          noremap = true;
        };
      }
    ];
  };
}
