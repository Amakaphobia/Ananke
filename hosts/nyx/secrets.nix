{ config, paths, ... }:
{
  sops = {
    defaultSopsFile = paths.root + "/secrets/nyx.yaml";

    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets = {

      # wifi profile:

      "wifi/home/ssid" = { };

      "wifi/home/password" = { };

      "ssh/github-private" = {
        owner = config.users.users.akio.name;
        group = config.users.users.akio.group;
        mode = "0400";
      };
    };

    templates."networkmanager.env" = {
      # r-- --- ---
      mode = "0400";

      # restartUnits: when the value of the secret changes, restart these
      restartUnits = [ "NetworkManager-ensure-profiles.service" ];

      content = ''
        HOME_WIFI_SSID=${config.sops.placeholder."wifi/home/ssid"}
        HOME_WIFI_PASSWORD=${config.sops.placeholder."wifi/home/password"}
      '';
    };
  };
}
