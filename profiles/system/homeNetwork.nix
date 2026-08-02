{ config, lib, ... }:
let
  cfg = config.ananke.profiles.system.core.networking.home;
in
{
  options.ananke.profiles.system.core.networking.home = {
    enable = lib.mkEnableOption "home network configuration";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.ensureProfiles = {

      # Before creating profiles load env variables from these files
      environmentFiles = [
        config.sops.templates."networkmanager.env".path
      ];

      # if the following profiles dont exist, create them
      profiles = {

        # home wifi profile
        wifi-at-home = {

          connection = {
            id = "Wifi at Home";
            type = "wifi";

            # Empty means every user of this machine knows about this connection
            permissions = "";
            autoconnect = true;
          };

          wifi = {
            # infrastructure = this machine connects to an existing access point
            mode = "infrastructure";
            ssid = "$HOME_WIFI_SSID";
          };

          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$HOME_WIFI_PASSWORD";
          };

          ipv4.method = "auto";
          ipv6.method = "auto";
        };
      };
    };
  };
}
