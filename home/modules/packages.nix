{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # pastel terminal color
    pastel
    # a jason processor
    jq
    # terminal git
    lazygit
    # find ...
    fd
    # funny man
    tldr
  ];

}
