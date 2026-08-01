{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim = {
      extraPackages = [ pkgs.nixfmt ];

      plugins.lsp.servers = {
        nixd = {
          enable = true;

          # set root markers
          rootMarkers = [
            "flake.nix"
            ".git"
          ];

          settings = {
            nixpkgs.expr = ''
              (builtins.getFlake (builtins.toString ./.))
                .inputs.nixpkgs.legacyPackages.x86_64-linux
            '';

            formatting.command = [ "nixfmt" ];

            options = {
              nixos.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nyx.options";

              home_manager.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nyx.options.home-manager.users.type.getSubOptions []";
            };
          };
        };
      };
    };
  };
}
