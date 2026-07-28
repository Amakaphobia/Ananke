{ ... }:

{
  imports = [
    ./modules.nix
    ./theme.nix

    ../../themes

  ];

  home = {
    username = "dave";
    homeDirectory = "/home/dave";
    stateVersion = "26.05";
  };
}
