{ ... }:

{
  imports = [
    ./modules.nix
    ./theme.nix
    ./locale-ger.nix
    ../../../home/themes
  ];

  home = {
    username = "dave";
    homeDirectory = "/home/dave";
    stateVersion = "26.05";
  };
}
