{ ... }:

{
  programs.nixvim.plugins.which-key = {
    enable = true;

    settings.plugins.presets.nav = false;
  };
}
