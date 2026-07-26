{ config, lib, ... }:
let
  cfg = config.ananka.desktop.hypr;
  lua = lib.generators.mkLuaInline;
in
{
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
    window_rule = [
      {
        name = "float-modal-windows";
        match.modal = true;
        float = true;
        center = true;
      }
      {
        name = "PavuControl Rules";
        match.class = "org.pulseaudio.pavucontrol";

        float = true;
      }
      {
        name = "Network-connection Editor Rules";
        match.class = "nm-connection-editor";

        float = true;
      }
      {
        name = "Obsidian Rules";
        match.class = "obsidian";

        workspace = "4";
      }
      {
        name = "Firefox Rules";
        match.class = "firefox";

        workspace = "3 silent";
      }

      # Default rules
      {
        name = "suppress-maximize-events";
        match.class = ".*";

        suppress_event = "maximize";
      }
      {
        # Fix some dragging issues with XWayland
        name = "fix-xwayland-drags";

        match = {
          class = "^$";
          title = "^$";
          xwayland = true;
          float = true;
          fullscreen = false;
          pin = false;
        };

        no_focus = true;
      }
    ];
    on = [
      {
        _args = [
          "workspace.active"
          (lua ''
            	function(workspace)
            	  if workspace.id == 3 then
            	    hl.exec_cmd("browser-once")
            	  end
            	end
          '')
        ];
      }

      {
        _args = [
          "window.open"
          (lua ''
            	function(window)
            	  local class = window.initial_class

            	  if class == nil or class == "" then
            	    class = window.class
            	  end

            	  if string.lower(class or "") ~= "spotify" then
            	    return
            	  end

            	  local occupied = {}
            	  local ignoredWorkspaceId =
            	    window.workspace ~= nil and window.workspace.id or nil

            	  for _, workspace in ipairs(hl.get_workspaces()) do
            	    if workspace.id >= 5 and not workspace.special then
            	      local windowCount = workspace.windows

            	      -- window.open runs after Spotify has already been placed on
            	      -- a workspace, so exclude the newly opened window itself.
            	      if workspace.id == ignoredWorkspaceId then
            		windowCount = windowCount - 1
            	      end

            	      occupied[workspace.id] = windowCount > 0
            	    end
            	  end

            	  local targetWorkspace = 5

            	  while occupied[targetWorkspace] do
            	    targetWorkspace = targetWorkspace + 1
            	  end

            	  hl.dispatch(hl.dsp.window.move({
            	    workspace = tostring(targetWorkspace),
            	    follow = true,
            	    window = window,
            	  }))
            	end
          '')
        ];
      }
    ];
    workspace_rule = [
      {
        workspace = "1";
        default_name = "";
        persistent = true;
      }
      {
        workspace = "2";
        default_name = "";
        persistent = true;
      }
      {
        workspace = "3";
        default_name = "";
        persistent = true;
      }
      {
        workspace = "4";
        default_name = "";
        persistent = true;
      }
      {
        workspace = "special:scratchpad";

        gaps_in = 8;
        gaps_out = 80;

        no_border = false;
        no_shadow = false;
        no_rounding = false;
        decorate = true;

        animation = "slidevert";
      }
    ];
  };
}
