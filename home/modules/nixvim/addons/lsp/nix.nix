{ ... }:
{
  programs.nixvim.plugins.lsp.servers = {
    nixd = {
      enable = true;

      settings.nixd = {
        nixpkgs.expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";

        formatting.command = [ "nixfmt" ];

        options = {
          nixos.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nyx.options";

          home_manager.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nyx.options.home-manager.users.type.getSubOptions []";
        };
      };
    };
  };
}
