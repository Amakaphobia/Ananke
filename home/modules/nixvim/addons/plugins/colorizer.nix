{ ... }:
{
  programs.nixvim.plugins.colorizer = {
    enable = true;

    settings = {
      filetypes = {
        __unkeyed-1 = "*";
        __unkeyed-2 = "!vim";

        css = {
          parsers.rgb.enable = true;
        };

        html = {
          parsers.names.enable = false;
        };
      };

      user_default_options = {
        mode = "virtualtext";
        names = false;
        virtualtext = "■ ";
      };
    };
  };
}
