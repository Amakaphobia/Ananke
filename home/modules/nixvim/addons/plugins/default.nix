{ ... }:
{
  imports = [
    ./autotag.nix
    ./blink-cmp.nix
    ./colorizer.nix
    ./conform-nvim.nix
    ./lualine.nix
    ./mini-ai.nix
    ./mini-surround.nix
    ./nvim-lint.nix
    ./snacks.nix
    ./treesitter.nix
    ./whichkey.nix
  ];

  programs.nixvim.plugins = {

    # commonly used code snippets
    friendly-snippets.enable = true;

    # better git integration
    gitsigns.enable = true;

    # auto pairs
    mini-pairs.enable = true;

    # better ai moves
    mini-ai.enable = true;
  };
}
