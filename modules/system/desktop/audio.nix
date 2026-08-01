{ config, lib, ... }:
let
  cfg = config.ananke.system.desktop.audio.pipewire;
in
{
  options.ananke.system.desktop.audio.pipewire = {
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
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;
      };
    };
  };
}
