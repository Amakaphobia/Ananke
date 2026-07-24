{ ... }:
{
  imports = [
    ./conform-nvim.nix
    ./treesitter.nix
    ./nvim-lint.nix
    ./snacks.nix
  ];

  programs.nixvim.plugins = {

    # autocomplete
    blink-cmp.enable = true;

    # commonly used code snippets
    friendly-snippets.enable = true;

    # bottom status bar
    lualine.enable = true;

    # hotkey helper
    which-key.enable = true;

    # better git integration
    gitsigns.enable = true;

    # auto pairs
    mini-pairs.enable = true;

    # better ai moves
    mini-ai.enable = true;

    # surround selected
    mini-surround.enable = true;
  };
}
