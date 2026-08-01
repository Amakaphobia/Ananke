{ pkgs, ... }:
{
  imports = [
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."akio" = {
    isNormalUser = true;
    description = "akio";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
