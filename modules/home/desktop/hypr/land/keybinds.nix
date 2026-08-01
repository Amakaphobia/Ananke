{ config, lib, ... }:
let
  cfg = config.ananke.home.desktop.hypr;

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
in
{
  options.ananke.home.desktop.hypr.commands = {
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "The command that opens the terminal. Default kitty.";
    };

    menu = lib.mkOption {
      type = lib.types.str;
      default = "fuzzel";
      description = "command that opens the menu. Default fuzzel.";
    };

    fileManager = lib.mkOption {
      type = lib.types.str;
      default = "thunar";
      description = "command that opens the FileManager. Default thunar.";
    };

    hyprLayoutToggle = lib.mkOption {
      type = lib.types.str;
      default = "echo 'No command defined.'";
      description = "toggle different layouts";
    };

    barToggle = lib.mkOption {
      type = lib.types.str;
      default = "echo 'No command defined.'";
      description = "command that toggles the statusbar.";
    };

    lockScreen = lib.mkOption {
      type = lib.types.str;
      default = "echo 'No command defined.'";
      description = "Opens the lockscreen if the lockscreen is not open yet.";
    };

    screenshotRegion = lib.mkOption {
      type = lib.types.str;
      default = "echo 'No command defined.'";
      description = "Screenshots a region";
    };
    screenshotComplete = lib.mkOption {
      type = lib.types.str;
      default = "echo 'No command defined.'";
      description = "Screenshot";
    };
  };
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = workspaceBinds ++ [
      # Applications
      (mkBind "${mainMod} + R" (exec cfg.commands.terminal))
      (mkBind "${mainMod} + SPACE" (exec cfg.commands.menu))
      (mkBind "${mainMod} + E" (exec cfg.commands.fileManager))

      # Lockscreen
      (mkBind "${mainMod} + CTRL + L" (exec cfg.commands.lockScreen))

      # Waybar
      (mkBind "${mainMod} + SHIFT + W" (exec cfg.commands.barToggle))

      # Screenshots
      (mkBind "${mainMod} + Print" (exec cfg.commands.screenshotRegion))
      (mkBind "${mainMod} + SHIFT + Print" (exec cfg.commands.screenshotComplete))

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
      (mkBind "${mainMod} + SHIFT + SPACE" (exec cfg.commands.hyprLayoutToggle))

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
        repeating = true;
      })
      (mkFlaggedBind "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") {
        locked = true;
        repeating = true;
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
      (mkFlaggedBind "XF86AudioNext" (exec "playerctl next") {
        locked = true;
      })
      (mkFlaggedBind "XF86AudioPause" (exec "playerctl play-pause") {
        locked = true;
      })
      (mkFlaggedBind "XF86AudioPlay" (exec "playerctl play-pause") {
        locked = true;
      })
      (mkFlaggedBind "XF86AudioPrev" (exec "playerctl previous") {
        locked = true;
      })
    ];
  };
}
