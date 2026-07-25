{ ... }:
{
  imports = [
    ./autotag.nix
    ./blink-cmp.nix
    ./colorizer.nix
    ./conform-nvim.nix
    ./lualine.nix
    ./nvim-lint.nix
    ./snacks.nix
    ./treesitter.nix
  ];

  programs.nixvim.plugins = {

    # commonly used code snippets
    friendly-snippets.enable = true;

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
