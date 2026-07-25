{ ... }:
{
  programs.nixvim.keymaps = [

    # ####
    # expected default behaviour
    # ####

    {
      mode = "n";
      key = "<ESC>";
      action.__raw = ":nohl<CR>";
      options.desc = "clear search";
    }

    # ####
    # window control
    # ####

    # Splitting

    {
      mode = "n";
      key = "<leader>wv";
      action.__raw = "<C-w>v";
      options.desc = "split window vertically";
    }
    {
      mode = "n";
      key = "<leader>ws";
      action.__raw = "<C-w>s";
      options.desc = "split window horizontally";
    }

    # split control

    {
      mode = "n";
      key = "<leader>we";
      action.__raw = "<C-w>=";
      options.desc = "make split equal in size";
    }
    {
      mode = "n";
      key = "<leader>wx";
      action.__raw = "<cmd>close<CR>";
      desc = "close current split";
    }

    # focus control

    {
      mode = "n";
      key = "<C-h>";
      action.__raw = "<C-w><C-h>";
      desc = "move focus to the left split";
    }
    {
      mode = "n";
      key = "<C-j>";
      action.__raw = "<C-w><C-j>";
      desc = "move focus to the lower split";
    }
    {
      mode = "n";
      key = "<C-k>";
      action.__raw = "<C-w><C-k>";
      options.desc = "move focus to the upper split";
    }
    {
      mode = "n";
      key = "<C-l>";
      action.__raw = "<C-w><C-l>";
      options.desc = "move focus to the right split";
    }
  ];
}
