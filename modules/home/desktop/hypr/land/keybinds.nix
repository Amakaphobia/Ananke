{ config, lib, ... }:
let
  cfg = config.ananke.profiles.home.desktop.hypr;
  cmds = cfg.commands;

  mainMod = "SUPER";

  # Mark a string as executable Lua instead of an ordinary quoted string.
  lua = lib.generators.mkLuaInline;

  mkBind = key: dispatcher: {
    _args = [
      key
      dispatcher
    ];
  };

  mkFlaggedBind = key: dispatcher: flags: {
    _args = [
      key
      dispatcher
      flags
    ];
  };

  # builtins.toJSON safely quotes the command as a Lua-compatible string.
  exec = command: lua "hl.dsp.exec_cmd(${builtins.toJSON command})";

  workspaceBinds = lib.concatMap (
    workspace:
    let
      # Workspace 10 is selected using the 0 key.
      key = if workspace == 10 then "0" else toString workspace;
    in
    [
      (mkBind "${mainMod} + ${key}" (lua "hl.dsp.focus({ workspace = ${toString workspace} })"))

      (mkBind "${mainMod} + SHIFT + ${key}" (
        lua "hl.dsp.window.move({ workspace = ${toString workspace} })"
      ))
    ]
  ) (lib.range 1 10);

  mkCommandOption =
    default: description:
    lib.mkOption {
      type = lib.types.str;
      inherit default description;
    };
in
{
  options.ananke.profiles.home.desktop.hypr.commands = {

    terminal = mkCommandOption "kitty" "Command that opens the Terminal. Default kitty";
    menu = mkCommandOption "fuzzel" "Command that opens the menu. Default fuzzel.";
    fileManager = mkCommandOption "thunar" "Command that opens the FileManager. Default thunar.";
    hyprLayoutToggle = mkCommandOption "echo 'No command defined.'" "toggle different layouts";
    barToggle = mkCommandOption "echo 'No command defined.'" "command that toggles the statusbar.";
    lockScreen = mkCommandOption "echo 'No command defined.'" "Opens the lockscreen if the lockscreen is not open yet.";
    screenshotRegion = mkCommandOption "echo 'No command defined.'" "Screenshots a region";
    screenshotComplete = mkCommandOption "echo 'No command defined.'" "Screenshot";
    hyprSunsetToggle = mkCommandOption "echo 'No command defined.'" "hyprsunset-toggle";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = workspaceBinds ++ [
      # Applications
      (mkBind "${mainMod} + R" (exec cmds.terminal))
      (mkBind "${mainMod} + SPACE" (exec cmds.menu))
      (mkBind "${mainMod} + E" (exec cmds.fileManager))

      # Lockscreen
      (mkBind "${mainMod} + CTRL + L" (exec cmds.lockScreen))

      # Waybar
      (mkBind "${mainMod} + SHIFT + W" (exec cmds.barToggle))
      # hyprsunset
      (mkBind "${mainMod} + SHIFT + E" (exec cmds.hyprSunsetToggle))

      # Screenshots
      (mkBind "${mainMod} + Print" (exec cmds.screenshotRegion))
      (mkBind "${mainMod} + SHIFT + Print" (exec cmds.screenshotComplete))

      #
      # Window Management
      #

      # Focus movement
      (mkBind "${mainMod} + h" (lua ''hl.dsp.focus({ direction = "l" })''))
      (mkBind "${mainMod} + l" (lua ''hl.dsp.focus({ direction = "r" })''))
      (mkBind "${mainMod} + k" (lua ''hl.dsp.focus({ direction = "u" })''))
      (mkBind "${mainMod} + j" (lua ''hl.dsp.focus({ direction = "d" })''))

      # window swap
      (mkBind "${mainMod} + SHIFT + h" (lua ''hl.dsp.window.swap({ direction = "l" })''))
      (mkBind "${mainMod} + SHIFT + l" (lua ''hl.dsp.window.swap({ direction = "r" })''))

      # make new master
      (mkBind "${mainMod} + M" (lua ''hl.dsp.layout("swapwithmaster")''))
      # Close the active window
      (mkBind "${mainMod} + W" (lua "hl.dsp.window.close()"))

      # Floating and fullscreen
      (mkBind "${mainMod} + SHIFT + F" (lua ''hl.dsp.window.float({ action = "toggle" })''))
      (mkBind "${mainMod} + F" (lua ''hl.dsp.window.fullscreen({ action = "toggle" })''))

      #
      # Mouse
      #

      # Move and resize with the mouse
      (mkFlaggedBind "${mainMod} + mouse:272" (lua "hl.dsp.window.drag()") {
        mouse = true;
      })
      (mkFlaggedBind "${mainMod} + mouse:273" (lua "hl.dsp.window.resize()") {
        mouse = true;
      })

      #
      # Workspace Management
      #

      # Previous workspace
      (mkBind "${mainMod} + TAB" (lua ''hl.dsp.focus({ workspace = "previous" })''))
      # Next workspace
      (mkBind "${mainMod} + RETURN" (lua ''hl.dsp.focus({ workspace = "e+1" })''))
      # Toggle between scrolling and master
      (mkBind "${mainMod} + SHIFT + SPACE" (exec cmds.hyprLayoutToggle))

      #
      # Scratchpad
      #

      # Toggle scratchpad
      (mkBind "${mainMod} + S" (lua ''hl.dsp.workspace.toggle_special("scratchpad")''))

      # Send active to scratchpad without following
      (mkBind "${mainMod} + SHIFT + S" (lua ''
        hl.dsp.window.move({
          workspace = "special:scratchpad",
          follow = false,
        })
      ''))

      #
      # Special Keys
      #

      # Volume
      (mkFlaggedBind "XF86AudioRaiseVolume" (exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") {
        locked = true;
        repeating = true;
      })
      (mkFlaggedBind "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") {
        locked = true;
        repeating = true;
      })
      (mkFlaggedBind "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") {
        locked = true;
        repeating = false;
      })
      (mkFlaggedBind "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") {
        locked = true;
        repeating = false;
      })

      # Brightness
      (mkFlaggedBind "XF86MonBrightnessUp" (exec "brightnessctl -e4 -n2 set 5%+") {
        locked = true;
        repeating = true;
      })
      (mkFlaggedBind "XF86MonBrightnessDown" (exec "brightnessctl -e4 -n2 set 5%-") {
        locked = true;
        repeating = true;
      })

      # Media
      (mkFlaggedBind "${mainMod} + PERIOD" (exec "playerctl next") {
        locked = true;
      })
      (mkFlaggedBind "${mainMod} + COMMA" (exec "playerctl play-pause") {
        locked = true;
      })
      (mkFlaggedBind "${mainMod} + SHIFT + PERIOD" (exec "playerctl previous") {
        locked = true;
      })
    ];
  };
}
