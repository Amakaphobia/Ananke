{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.home.shell.scripts;
  helper = import (paths.lib + "/helper.nix") { inherit lib; };

  sessionPath = "$HOME/.local/bin";

  shellScripts = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".sh" name) (
    builtins.readDir paths.scripts
  );
in
{
  options.ananke.home.shell.scripts = {
    enable = helper.mkDefaultOnOption "shell scripts";
  };

  config = lib.mkIf (config.ananke.shell.addons.enable && cfg.enable) {
    home.file = lib.mapAttrs' (
      filename: _:
      lib.nameValuePair ".local/bin/${lib.removeSuffix ".sh" filename}" {
        source = paths.scripts + "/${filename}";
        executable = true;
      }
    ) shellScripts;

    home.sessionPath = [
      sessionPath
    ];
  };
}
