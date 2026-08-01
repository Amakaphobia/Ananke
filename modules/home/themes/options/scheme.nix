{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;

  # 6 hexadecimals
  hexColor = types.strMatching "[0-9a-fA-F]{6}";

  theme = config.ananke.theme;

  layout = import ../palettes/palette-layout.nix;
  inherit (layout) terminalColorRoles semanticColorRoles;

  semanticColorOptions = lib.listToAttrs (
    map (role: {
      name = "${role.name}";
      value = mkOption {
        type = hexColor;
        description = "${role.description}";
      };
    }) semanticColorRoles
  );

  terminalColorOptions = lib.listToAttrs (
    map (role: {
      name = "${role.name}";
      value = mkOption {
        type = hexColor;
        description = "${role.description}";
      };
    }) terminalColorRoles
  );

  # map over list of ordered roles and join the role name from that list with the color from the users theme
  # join both with a :
  # gather into list
  listOfInfoLinesTerminal = map (
    role: "${role.name} : ${theme.scheme.terminal.${role.name}}"
  ) terminalColorRoles;
  terminalList = lib.strings.join "\n" listOfInfoLinesTerminal;

  # map over list of ordered roles and join the role name from that list with the color from the users theme
  # join both with a :
  # gather into list
  listOfInfoLinesSemantic = map (
    role: "${role.name} : ${theme.scheme.roles.${role.name}}"
  ) semanticColorRoles;
  semanticList = lib.strings.join "\n" listOfInfoLinesSemantic;

  infoText = semanticList + "\n\n" + terminalList;
in
{
  # create global color scheme
  options.ananke.theme.scheme = mkOption {
    description = "global desktop color scheme.";

    type = types.submodule {
      options = {
        name = mkOption {
          type = types.str;
          description = "Human-readable theme name.";
        };

        author = mkOption {
          type = types.str;
          description = "name of the author";
        };

        palette = mkOption {
          type = types.attrsOf hexColor;
          description = "Raw named color palette.";
        };

        roles = mkOption {
          description = "Application-independent semantic colors.";

          type = types.submodule {
            options = semanticColorOptions;
          };
        };

        terminal = mkOption {
          type = types.submodule {
            options = terminalColorOptions;
          };
          description = "ANSI terminal colors named color0 through color15.";
        };
      };
    };
  };

  # link the file to home directory
  config.home.file."color-info.txt".text = infoText;
}
