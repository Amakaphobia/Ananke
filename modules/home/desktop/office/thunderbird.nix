{
  config,
  lib,
  ...
}:
let
  cfg = config.ananke.home.desktop.thunderbird;
in
{
  options.ananke.home.desktop.thunderbird = {
    enable = lib.mkEnableOption "Thunderbird";
    default.enable = lib.mkEnableOption "Thunderbird as default mail client.";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.thunderbird = {
        enable = true;

        policies = {
          # no telemetry for me
          DisableTelemetry = true;

          # set ddg
          SearchEngines = {
            Default = "DuckDuckGo";
          };
        };
        profiles.default = {
          isDefault = true;

          settings = {
            # "Always show scrollbars".
            "widget.gtk.overlay-scrollbars.enabled" = false;

            # Mark message as read after three seconds.
            "mailnews.mark_message_read.auto" = true;
            "mailnews.mark_message_read.delay" = true;
            "mailnews.mark_message_read.delay.interval" = 3;

            # Disable the Thunderbird start page
            "mailnews.start_page.enabled" = false;
          };
        };
      };
    })
    (lib.mkIf (cfg.enable && cfg.default.enable) {
      xdg.mimeApps = {
        enable = true;

        defaultApplications = {
          # mailto:
          "x-scheme-handler/mailto" = "thunderbird.desktop";

          # Individual email message files
          "message/rfc822" = "thunderbird.desktop";

          # Mailbox archives
          "application/mbox" = "thunderbird.desktop";
        };
      };
    })
  ];
}
