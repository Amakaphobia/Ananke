{ ... }:
{
  imports = [
    ./bootloader.nix
    ./locale.nix
    ./locales/locale-ger.nix
    ./networking.nix
    ./nix.nix
    ./sudo.nix
    ./printing.nix
  ];
}
