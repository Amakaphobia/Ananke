{ lib, ... }:
{
  # Like mkEnableOption but defaults to true;

  mkDefaultOnOption =
    package:
    lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install ${package}";
    };

  mkStringFallbackOption =
    fallback: description:
    lib.mkOption {
      type = lib.types.str;
      default = fallback;
      inherit description;
    };
}
