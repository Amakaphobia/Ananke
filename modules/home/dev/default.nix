{ lib, ... }:
{
  imports = [
    ./shell.nix
    ./nix.nix
  ];

  options.ananke.modules.dev = {
    enable = lib.mkEnableOption "dev tools";
  };
}
