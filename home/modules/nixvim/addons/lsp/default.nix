{ ... }:
{
  imports = [
    ./lua.nix
    ./nix.nix
  ];

  programs.nixvim.plugins.lsp = {
    enable = true;
  };
}
