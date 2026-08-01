{ paths, ... }:

{
  imports = [
    ./modules.nix
    ./theme.nix
    ./zshAliases.nix
    (paths.modules + "/home/themes")
  ];

  home = {
    username = "dave";
    homeDirectory = "/home/dave";
    stateVersion = "26.05";
  };
}
