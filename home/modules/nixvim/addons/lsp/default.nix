{ ... }:
{
  imports = [
    ./bash.nix
    ./css.nix
    ./json.nix
    ./lua.nix
    ./markdown.nix
    ./nix.nix
  ];

  programs.nixvim.plugins.lsp = {
    enable = true;
  };
}
