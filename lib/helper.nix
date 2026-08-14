{ lib, ... }:
let
  # make boolean install option
  mkOption =
    name: value:
    lib.mkOption {
      description = "Whether to install ${name}";
      default = value;
      type = lib.types.bool;
    };
  # Like mkEnableOption but defaults to true;

  mkDefaultOnOption = name: mkOption name true;

  mkStringFallbackOption =
    fallback: description:
    lib.mkOption {
      type = lib.types.str;
      default = fallback;
      inherit description;
    };
in
{
  inherit mkOption mkDefaultOnOption mkStringFallbackOption;
}
