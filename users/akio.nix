{ config, pkgs, ... }:
{
  imports = [
  ];

  users.mutableUsers = false;

  users.users."akio" = {
    isNormalUser = true;
    description = "akio";

    hashedPasswordFile = config.sops.secrets."users/akio/password".path;

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    shell = pkgs.zsh;
  };
}
