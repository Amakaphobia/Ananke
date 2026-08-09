{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins.which-key = {
      enable = true;

      settings = {
        plugins.presets.nav = false;

        spec = [
          {
            __unkeyed-1 = "<leader>b";
            group = "Buffers";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "Code";
          }
          {
            __unkeyed-1 = "<leader>f";
            group = "Find";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "Git";
          }
          {
            __unkeyed-1 = "<leader>n";
            group = "Notifications";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "search/discover";
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "Terminal";
          }
          {
            __unkeyed-1 = "<leader>w";
            group = "Windows";
          }
        ];
      };
    };
  };
}
