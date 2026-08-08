{ config, paths, ... }:
let
  profsys = paths.profiles + "/system";
  profhard = paths.profiles + "/hardware";
in
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-acceleration.nix
    ./disk-config.nix

    ./secrets.nix

    (profsys + "/core.nix")
    (profsys + "/desktop.nix")
    (profsys + "/homeNetwork.nix")
    (profsys + "/health.nix")

    (profhard + "/laptop.nix")

    (paths.users + "/akio.nix")
  ];

  config = {
    ananke = {

      system.core.locale.ger.enable = true;

      profiles = {
        hardware.laptop = {
          enable = true;
          bluetooth.enable = true;
        };
        system = {
          core = {
            enable = true;
            networking.home.enable = true;
          };
          health.enable = true;
          desktop.enable = true;

        };
      };
    };

    home-manager.users.akio.ananke.home.desktop.services.serviceCheck.enable =
      config.ananke.profiles.system.health.enable;

    networking.hostName = "nyx"; # Define your hostname.
    system.stateVersion = "26.05"; # No changerino!
  };
}
