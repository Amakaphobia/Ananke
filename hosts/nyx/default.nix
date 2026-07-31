{ self, ... }:
let
  profsys = "${self}/profiles/system";
in
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-acceleration.nix

    "${profsys}/core.nix"
    "${profsys}/desktop.nix"
    "${profsys}/laptop.nix"

    "${self}/users/dave.nix"
  ];

  config = {
    ananke = {

      system.core.locale.ger.enable = true;
      machine.laptop.enable = true;

      profiles = {
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
