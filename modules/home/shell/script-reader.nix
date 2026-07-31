{ lib, paths, ... }:
let
  sessionPath = "$HOME/.local/bin";

  shellScripts = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".sh" name) (
    builtins.readDir paths.scripts
  );
in
{
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
}
