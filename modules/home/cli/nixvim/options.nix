{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.opts = {
      # Interface
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 4;

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

      # Confirm closing unsaved buffers
      confirm = true;

      # enable linewrap
      wrap = true;
      # prefer linewrapping on suitable characters
      linebreak = true;
      # carry indentation over
      breakindent = true;

      # Split directions
      splitbelow = true;
      splitright = true;

      # substitution preview
      inccommand = "nosplit";

      # reload buffer after source changes externally
      autoread = true;

      # time before idle events are triggered
      updatetime = 200;
      timeoutlen = 300;

      # Remove the ~ from end of buffer
      fillchars = {
        eob = " ";
      };
    };
  };
}
