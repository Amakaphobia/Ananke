{ config, lib, ... }:
let
  cfg = config.ananke.cli.nixvim.enable;
in
{
  imports = [
    ./autotag.nix
    ./blink-cmp.nix
    ./colorizer.nix
    ./conform-nvim.nix
    ./lualine.nix
    ./markdown.nix
    ./mini-ai.nix
    ./mini-pairs.nix
    ./mini-surround.nix
    ./nvim-lint.nix
    ./snacks.nix
    ./treesitter.nix
    ./whichkey.nix
  ];
  config = lib.mkIf cfg {
    programs.nixvim.plugins = {

      # commonly used code snippets
      friendly-snippets.enable = true;

      # better git integration
      gitsigns.enable = true;
    };
  };
}
