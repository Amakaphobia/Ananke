{
  config,
  lib,
  ...
}:
let
  cfg = config.ananke.profiles.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim = {
      plugins.todo-comments = {
        enable = true;
      };

      keymaps = [
        {
          mode = "n";
          key = "]t";
          action.__raw = ''
            function()
              require("todo-comments").jump_next()
            end
          '';
          options.desc = "Next todo comment";
        }
        {
          mode = "n";
          key = "[t";
          action.__raw = ''
            function()
              require("todo-comments").jump_prev()
            end
          '';
          options.desc = "Previous todo comment";
        }
      ];
    };
  };
}
