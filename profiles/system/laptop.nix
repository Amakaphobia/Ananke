{ ... }:
{
  imports = [
    ../modules/hardware/hibernation.nix
    ../modules/hardware/power-profiles.nix
    ../modules/hardware/touchpad.nix
    ../modules/hardware/lidswitch.nix
  ];
}
