{
  pkgs,
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.home.cli.utilities;

  helper = import (paths.lib + "/helper.nix") { inherit lib; };

in
{
  options.ananke.home.cli.utilities = {
    enable = lib.mkEnableOption "utilities";

    pastel.enable = helper.mkDefaultOnOption "pastel";
    just.enable = helper.mkDefaultOnOption "just";
    jq.enable = helper.mkDefaultOnOption "jq";
    lazygit.enable = helper.mkDefaultOnOption "lazygit";
    fd.enable = helper.mkDefaultOnOption "fd";
    tldr.enable = helper.mkDefaultOnOption "tldr";
    nixfmt.enable = helper.mkDefaultOnOption "nixfmt";
    nix-tree.enable = helper.mkDefaultOnOption "nix-tree";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      # pastel terminal color
      lib.optional cfg.pastel.enable pkgs.pastel
      # a jason processor
      ++ lib.optional cfg.jq.enable pkgs.jq
      # just
      ++ lib.optional cfg.just.enable pkgs.just
      # terminal git
      ++ lib.optional cfg.lazygit.enable pkgs.lazygit
      # find ...
      ++ lib.optional cfg.fd.enable pkgs.fd
      # funny man
      ++ lib.optional cfg.tldr.enable pkgs.tldr
      # nix formatter
      ++ lib.optional cfg.nixfmt.enable pkgs.nixfmt
      # display dependency graph
      ++ lib.optional cfg.nix-tree.enable pkgs.nix-tree;
  };
}
