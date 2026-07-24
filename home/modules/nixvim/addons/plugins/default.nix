{ ... }:
{
  imports = [
    ./conform-nvim.nix
    ./treesitter.nix
    ./nvim-lint.nix
  ];

  programs.nixvim.plugins = {
    # TODO: super tab

    # autocomplete
    blinkcmp.enable = true;

    # commonly used code snippets
    friendly-snippets.enable = true;

    # bottom status bar
    lualine.enable = true;

    # hotkey helper
    which-key.enable = true;

    # better git integration
    gitsigns.enable = true;

    # file tree
    snacks.enable = true;

    # auto pairs
    mini-pairs.enable = true;

    # better ai moves
    mini-ai.enable = true;

    # surround selected
    mini-surround.enable = true;
  };
}
