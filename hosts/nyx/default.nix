{ paths, ... }:
let
  profsys = paths.profiles + "/system";
  profhard = paths.profiles + "/hardware";
in
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-acceleration.nix
    ./disk-config.nix

    (profsys + "/core.nix")
    (profsys + "/desktop.nix")

    (profhard + "/laptop.nix")

    (paths.users + "/akio.nix")
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
