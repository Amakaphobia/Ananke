{ ... }:
{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        transparent_background = true;
        float.transparent = true;
      };
    };
  };
}
