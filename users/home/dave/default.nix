{ ... }:

{
  imports = [
    ./modules.nix
    ./theme.nix
    ./zshAliases.nix
    ../../../home/themes
  ];

  home = {
    username = "dave";
    homeDirectory = "/home/dave";
    stateVersion = "26.05";
  };
}
