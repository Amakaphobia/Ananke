{ config, lib, ... }:
let
  cfg = config.ananke.system.core.nix;
in
{
  options.ananke.system.core.nix = {
    enable = lib.mkEnableOption "nix base settings";
    allowGarbageCollection = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow automatic garbage collection weekly older than 2 months. Defaults to true.";
    };

    allowUnfree = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow unfree packages. Defaults to true.";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = cfg.allowUnfree;

    programs.nh = {
      enable = true;

    };
    environment.variables.NH_SEARCH_CHANNEL = "nixos-${config.system.nixos.release}";

    nix = {
      settings = {
        # Flakes
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
      };

      #automatic weekly garbage colletion, protects the current generation
      gc = {
        automatic = cfg.allowGarbageCollection;
        dates = "weekly";
        options = "--delete-older-than 60d";
      };
    };
  };
}
