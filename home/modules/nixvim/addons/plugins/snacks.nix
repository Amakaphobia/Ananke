{ ... }:
{
  programs.nixvim.plugins.snacks = {
    enable = true;

    settings = {
      explorer.enabled = true;
      picker.enabled = true;

      picker.sources.explorer.jump.close = true;
    };
  };
}
