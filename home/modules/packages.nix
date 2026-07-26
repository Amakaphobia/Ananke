{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
