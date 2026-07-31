{ pkgs, ... }:

let
  # make font option given a package and name
  mkFont = package: name: {
    inherit package name;
  };

  notoPackage = pkgs.noto-fonts;
in
{
  notoSans = mkFont notoPackage "Noto Sans";
  notoSerif = mkFont notoPackage "Noto Serif";
  notoEmoji = mkFont pkgs.noto-fonts-color-emoji "Noto Color Emoji";

  mapleMono = mkFont pkgs.maple-mono.NF "Maple Mono NF";
  lora = mkFont pkgs.lora "Lora";

  jetBrainsMono = mkFont pkgs.nerd-fonts.jetbrains-mono "JetBrainsMono Nerd Font Mono";

  liberation = mkFont pkgs.liberation_ttf "Liberation Sans";
  nerdSymbols = mkFont pkgs.nerd-fonts.symbols-only "Symbols Nerd Font";
}
