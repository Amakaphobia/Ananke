{ config, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;

  transparentMode = accent: {
    a = {
      fg = accent;
      bg = "NONE";
      gui = "bold";
    };

    b = {
      fg = accent;
      bg = "NONE";
    };

    c = {
      fg = colors.base05;
      bg = "NONE";
    };
  };
in
{
  programs.nixvim.plugins.lualine = {
    enable = true;

    settings.options = {
      theme = {
        normal = transparentMode colors.base0D;
        insert = transparentMode colors.base0B;
        visual = transparentMode colors.base0E;
        replace = transparentMode colors.base08;
        command = transparentMode colors.base0A;
        terminal = transparentMode colors.base0C;

        inactive = {
          a = {
            fg = colors.base03;
            bg = "NONE";
          };

          b = {
            fg = colors.base03;
            bg = "NONE";
          };

          c = {
            fg = colors.base03;
            bg = "NONE";
          };
        };
      };

      section_separators = "";
      component_separators = "";
    };
  };
}
