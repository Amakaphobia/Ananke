{ ... }:
{
  imports = [
    ./bootloader.nix
    ./locale.nix
    ./locales/locale-ger.nix
    ./networking.nix
    ./nix.nix
    ./printing.nix
  ];
}
