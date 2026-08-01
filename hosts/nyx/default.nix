{ paths, ... }:
let
  profsys = paths.profiles + "/system";
in
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-acceleration.nix

    (profsys + "/core.nix")
    (profsys + "/desktop.nix")
    (profsys + "/laptop.nix")

    (paths.users + "/dave.nix")
  ];

  config = {
    ananke = {

      system.core.locale.ger.enable = true;

      profiles = {
        hardware.laptop.enable = true;
        system = {
          core.enable = true;
          desktop.enable = true;
        };
      };
    };

    networking.hostName = "nyx"; # Define your hostname.
    system.stateVersion = "26.05"; # No changerino!
  };
}
