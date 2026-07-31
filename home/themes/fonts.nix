{ pkgs, self, ... }:
let
  fonts = import "${self}/lib/fontCatalog.nix" { inherit pkgs; };
  notoComplete = [
    fonts.notoSans.package
    fonts.notoEmoji.package
  ];
in
{
  # Install fonts into home manager profile
  home.packages =
    with pkgs;
    [
      nerd-fonts.symbols-only
      liberation_ttf
      # make sure maple is installed regardless of theme choices
      maple-mono.NF
    ]
    ++ notoComplete;

  # default fonts
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      sansSerif = [
        "Symbols Nerd Font"
      ];
      serif = [
        "Symbols Nerd Font"
      ];
    };
  };
}
