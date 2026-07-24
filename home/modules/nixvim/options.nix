{ ... }:
{
  programs.nixvim.opts = {
    # Interface
    number = true;
    relativenumber = true;
    signcolumn = "yes";

    # Indentation
    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;
    softtabstop = 2;

    # Search
    ignorecase = true;
    smartcase = true;

    # Editing
    undofile = true;
    swapfile = false;
  };
}
