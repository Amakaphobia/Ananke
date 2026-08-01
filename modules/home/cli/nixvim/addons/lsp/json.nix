{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins = {
      lsp.servers.jsonls.enable = true;

      schemastore = {
        enable = true;

        json.enable = true;

        # Do not configure YAML schemas until yamlls is enabled.
        yaml.enable = false;
      };
    };
  };
}
