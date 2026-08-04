{
  self,
  pkgs,
  nixosConfiguration,
  paths,
}:
let
  checkScripts = paths.scripts + "/checks";
in
{
  formatting =
    pkgs.runCommand "check-formatting"
      {
        nativeBuildInputs = [ pkgs.nixfmt-tree ];
      }
      ''
        cp -r ${self} source
        chmod -R u+w source

        ${pkgs.bash}/bin/bash \
          ${checkScripts}/formatting.sh \
          "$PWD/source"

        touch "$out"
      '';

  statix =
    pkgs.runCommand "check-statix"
      {
        nativeBuildInputs = [ pkgs.statix ];
      }
      ''
        ${pkgs.bash}/bin/bash \
          ${checkScripts}/statix.sh \
          ${self}

        touch "$out"
      '';

  deadnix =
    pkgs.runCommand "check-deadnix"
      {
        nativeBuildInputs = [ pkgs.deadnix ];
      }
      ''
        ${pkgs.bash}/bin/bash \
          ${checkScripts}/deadnix.sh \
          ${self}

        touch "$out"
      '';

  nyx = nixosConfiguration.config.system.build.toplevel;
}
