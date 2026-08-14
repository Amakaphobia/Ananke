{ config, lib, ... }:
let
  cfg = config.ananke.profiles.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins.lsp.servers.bashls.enable = true;
  };
}
