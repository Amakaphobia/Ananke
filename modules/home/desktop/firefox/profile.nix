{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.desktop.firefox;
in
{
  programs.firefox = lib.mkIf cfg.enable {

    profiles.default = {
      id = 0;
      isDefault = true;

      # make ddg the default
      search = {
        force = true;
        default = "ddg";

        engines = {
          "bing".metaData.hidden = true;
          "amazondotcom-us".metaData.hidden = true;
          "google".metaData.hidden = true;
        };
      };

      # read the following file from betterfox into userjs:
      preConfig = builtins.readFile "${inputs.betterfox}/user.js";

      settings = {
        # preffered languages for websites in order
        "intl.accept_languages" = "en-US, en, de-DE";
        # Always show the bookmarks toolbar
        "browser.toolbars.bookmarks.visibility" = "always";
        # resume previous session on startup
        "browser.startup.page" = 3;
        # hide about:config warning
        "browser.aboutConfig.showWarning" = false;
        # just making sure that stays off
        "browser.ctrlTab.sortByRecentlyUsed" = false;
        # i speak that myself
        "browser.translations.neverTranslateLanguages" = "de";
        # enable js in dev console
        "devtools.chrome.enabled" = true;
        # allow userChrome.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # disable bell sounds
        "accessibility.typeaheadfind.enablesound" = false;
        # activate middle click to scroll
        "general.autoScroll" = true;

        # Privacy
        "privacy.userContext.enabled" = true;

        # my browser dont need sensors
        "device.sensors.enabled" = false;
        # my browser dont need location either
        "geo.enabled" = false;

        # New tab page
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;

        # Disable Firefox Home weather completely
        "browser.newtabpage.activity-stream.showWeather" = false;
        "browser.newtabpage.activity-stream.system.showWeather" = false;

        # Automatically deny permission requests
        "permissions.default.geo" = 2;
        "permissions.default.persistent-storage" = 2;

        # Disable telemetry
        "extensions.webcompat-reporter.enabled" = false; # don't report compability problems to mozilla

        # disable features I dont use
        "extensions.pocket.enabled" = false;
        "extensions.abuseReport.enabled" = false; # dont show report abuse button
        "extensions.formautofill.creditCards.enabled" = false; # dont autofill credit cards
        "identity.fxaccounts.enabled" = false; # disable firefoxes login

        # block drm media
        "media.eme.enabled" = false;

        # disable annoying web features
        "dom.private-attribution.submission.enabled" = false; # No PPA for me pls

        # automatically approve extensions installed through home.manager
        "extensions.autoDisableScopes" = 0;
      };

      # Add ons go here
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        darkreader
        hover-zoom-plus
        reddit-enhancement-suite
      ];

      # override githubs code views with my font stack
      userContent = ''
        @-moz-document domain("github.com") {
          .blob-code,
          .blob-code-inner,
          .react-code-text {
            font-family:
              "JetBrainsMono Nerd Font Mono",
              "Symbols Nerd Font Mono",
              ui-monospace,
              monospace !important;
          }
        }
        @-moz-document domain("chatgpt.com") {
          pre,
          code {
            font-family:
              "JetBrainsMono Nerd Font Mono",
              "Symbols Nerd Font Mono",
              ui-monospace,
              monospace !important;
          }
        }
      '';
    };
  };
}
