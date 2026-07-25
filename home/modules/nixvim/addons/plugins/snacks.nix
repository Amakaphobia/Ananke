{ ... }:
{
  programs.nixvim = {
    plugins.snacks = {
      enable = true;

      settings = {
        explorer.enabled = true;
        picker.enabled = true;

        picker.sources.explorer.jump.close = true;
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action.__raw = "function() Snacks.explorer() end";
        options.desc = "File explorer";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action.__raw = "function() Snacks.picker.files() end";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action.__raw = "function() Snacks.picker.grep() end";
        options.desc = "Grep files";
      }
    ];
  };
}
