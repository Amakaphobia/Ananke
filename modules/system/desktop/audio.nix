{ config, lib, ... }:
let
  cfg = config.ananke.profiles.system.desktop.audio.pipewire;
in
{
  options.ananke.profiles.system.desktop.audio.pipewire = {
    enable = lib.mkEnableOption "pipewire";
  };

  config = lib.mkIf cfg.enable {
    # allow access for audio server
    security.rtkit.enable = true;
    services = {
      # dont want that
      pulseaudio.enable = false;

      # enable pipewire and alsa
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
    };
  };
}
