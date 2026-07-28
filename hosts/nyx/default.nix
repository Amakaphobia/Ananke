{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-acceleration.nix

    ../../profiles/system/core.nix
    ../../profiles/system/desktop.nix
    ../../profiles/system/laptop.nix

    ../../users/dave.nix
  ];

  config = {
    ananke.profiles = {
      system = {
        core.enable = true;
      };
    };

    networking.hostName = "nyx"; # Define your hostname.
    system.stateVersion = "26.05"; # No changerino!
  };
}
