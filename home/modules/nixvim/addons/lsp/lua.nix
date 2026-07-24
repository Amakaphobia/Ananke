{ ... }:
{
  programs.nixvim.plugins.lsp.servers = {
    lua_ls = {
      enable = true;

      settings = {
        runtime.version = "LuaJIT";

        diagnostics.globals = [
          "vim"
        ];

        workspace.checkThirdParty = false;
      };
    };
  };
}
