{ config, lib, ... }:
let
  cfg = config.ananke.cli.git;
in
{
  options.ananke.cli.git = {
    enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.ananke.system.git;
        message = "Git is not installed at system level. Use config.ananke.system.git = true";
      }
    ];

    programs = {
      git = {
        # git is a system install
        package = null;

        settings = {
          user.Name = "amakaphobia";
          user.Email = "29711914+Amakaphobia@users.noreply.github.com";

          alias = {
            s = "status --short --branch";
            st = "status";
            a = "add --all";
            c = "commit";
            cm = "commit -m";
            ca = "commit --amend";
            p = "push";
          };
        };
      };
    };
  };
}
