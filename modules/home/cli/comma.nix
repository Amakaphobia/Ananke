{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.comma;
in
{
  options.ananke.home.cli.comma = {
    enable = lib.mkEnableOption "Comma with nix index db";
  };

  config = lib.mkIf cfg.enable {
    programs.nix-index-database.comma.enable = true;
  };
}
