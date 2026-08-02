{ paths, ... }:

{
  imports = [
    ./modules.nix
    ./theme.nix
    ./zshAliases.nix
    ./ssh-settings.nix
    (paths.modules + "/home/themes")
  ];

  home = {
    username = "akio";
    homeDirectory = "/home/akio";
    stateVersion = "26.05";
  };
}
