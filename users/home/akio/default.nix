{ paths, ... }:

{
  imports = [
    ./modules.nix
    ./theme.nix
    ./zshAliases.nix
    (paths.modules + "/home/themes")
  ];

  home = {
    username = "akio";
    homeDirectory = "/home/akio";
    stateVersion = "26.05";
  };
}
