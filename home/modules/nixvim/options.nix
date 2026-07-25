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

    # Folding
    foldlevel = 99;
    foldlevelstart = 99;

    # Search
    ignorecase = true;
    smartcase = true;

    # Editing
    undofile = true;
    swapfile = false;

    # Remove the ~ from end of buffer
    fillchars = {
      eob = " ";
    };
  };
}
