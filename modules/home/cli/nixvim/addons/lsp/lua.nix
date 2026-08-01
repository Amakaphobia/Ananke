{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins.lsp.servers = {
      lua_ls = {
        enable = true;

        settings.Lua = {
          runtime.version = "LuaJIT";

          diagnostics.globals = [
            "vim"
          ];

          workspace.checkThirdParty = false;
        };
      };
    };
  };
}
