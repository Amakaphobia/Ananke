{ config, lib, ... }:
let
  cfg = config.ananke.desktop.obsidian;
in
{
  config = lib.mkIf cfg.enable {
    programs.obsidian.defaultSettings.corePlugins = [
      {
        name = "backlink";
        settings = {
          backlinkInDocument = true;
        };
      }
      "bases"
      "bookmarks"
      {
        name = "canvas";
        settings = {
          snapToObjects = true;
          snapToGrid = true;
          zoomBreakpoint = 0.8;
          defaultWheelBehavior = "zoom";
        };
      }
      "command-palette"
      {
        name = "daily-notes";
        settings = {
          folder = "05 - Journal/daily Notes";
        };
      }
      "editor-status"
      "file-explorer"
      "footnotes"
      "global-search"
      "graph"
      "note-composer"
      "outgoing-link"
      "outline"
      "page-preview"
      "properties"
      "slash-command"
      {
        name = "switcher";
        settings = {
          showExistingOnly = true;
          showAttachments = true;
          showAllFileTypes = false;
        };
      }
      "tag-pane"
      "templates"
      "word-count"
    ];
  };
}
