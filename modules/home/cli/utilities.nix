{
  pkgs,
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.profiles.home.cli.utilities;

  helper = import (paths.lib + "/helper.nix") { inherit lib; };
in
{
  options.ananke.profiles.home.cli.utilities = {
    enable = lib.mkEnableOption "utilities";

    bat.enable = helper.mkDefaultOnOption "bat";
    fastfetch.enable = helper.mkDefaultOnOption "fastfetch";
    fd.enable = helper.mkDefaultOnOption "fd";
    just.enable = helper.mkDefaultOnOption "just";
    jq.enable = helper.mkDefaultOnOption "jq";
    lazygit.enable = helper.mkDefaultOnOption "lazygit";
    nixfmt.enable = helper.mkDefaultOnOption "nixfmt";
    nix-tree.enable = helper.mkDefaultOnOption "nix-tree";
    pastel.enable = helper.mkDefaultOnOption "pastel";
    tldr.enable = helper.mkDefaultOnOption "tldr";
    tree.enable = helper.mkDefaultOnOption "tree";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      # prettier cat
      lib.optional cfg.bat.enable pkgs.bat
      # terminal eye candy
      ++ lib.optional cfg.fastfetch.enable pkgs.fastfetch
      # find ...
      ++ lib.optional cfg.fd.enable pkgs.fd
      # just
      ++ lib.optional cfg.just.enable pkgs.just
      # a jason cfgcessor
      ++ lib.optional cfg.jq.enable pkgs.jq
      # terminal git
      ++ lib.optional cfg.lazygit.enable pkgs.lazygit
      # nix formatter
      ++ lib.optional cfg.nixfmt.enable pkgs.nixfmt
      # display dependency graph
      ++ lib.optional cfg.nix-tree.enable pkgs.nix-tree
      # pastel terminal color
      ++ lib.optional cfg.pastel.enable pkgs.pastel
      # funny man
      ++ lib.optional cfg.tldr.enable pkgs.tldr
      # tree
      ++ lib.optional cfg.tree.enable pkgs.tree;
  };
}
