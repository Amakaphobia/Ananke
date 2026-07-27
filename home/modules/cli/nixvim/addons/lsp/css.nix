{ config, lib, ... }:
let
  cfg = config.ananke.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins.lsp.servers.cssls.enable = true;
  };
}
