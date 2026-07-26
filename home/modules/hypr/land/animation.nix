{ config, lib, ... }:
let
  cfg = config.ananka.desktop.hypr;
  mkBezier = name: points: {
    _args = [
      name
      {
        type = "bezier";
        inherit points;
      }
    ];
  };
in
{
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {

    # turn on animations master toggle
    config.animations.enabled = true;

    curve = [
      (mkBezier "easeOutQuint" [
        [
          0.23
          1
        ]
        [
          0.32
          1
        ]
      ])
      (mkBezier "easeInOutCubic" [
        [
          0.65
          0.05
        ]
        [
          0.36
          1
        ]
      ])
      (mkBezier "linear" [
        [
          0
          0
        ]
        [
          1
          1
        ]
      ])
      (mkBezier "almostLinear" [
        [
          0.5
          0.5
        ]
        [
          0.75
          1
        ]
      ])
      (mkBezier "quick" [
        [
          0.15
          0
        ]
        [
          0.1
          1
        ]
      ])
      {
        _args = [
          "easy"
          {
            type = "spring";
            mass = 1;
            stiffness = 71.2633;
            dampening = 15.8273644;
          }
        ];
      }
    ];

    animation = [
      {
        leaf = "global";
        enabled = true;
        speed = 10;
        bezier = "default";
      }
      {
        leaf = "border";
        enabled = true;
        speed = 5.39;
        bezier = "easeOutQuint";
      }
      {
        leaf = "windows";
        enabled = true;
        speed = 4.79;
        spring = "easy";
      }
      {
        leaf = "windowsIn";
        enabled = true;
        speed = 4.1;
        spring = "easy";
        style = "popin 87%";
      }
      {
        leaf = "windowsOut";
        enabled = true;
        speed = 1.49;
        bezier = "linear";
        style = "popin 87%";
      }
      {
        leaf = "fadeIn";
        enabled = true;
        speed = 1.73;
        bezier = "almostLinear";
      }
      {
        leaf = "fadeOut";
        enabled = true;
        speed = 1.46;
        bezier = "almostLinear";
      }
      {
        leaf = "fade";
        enabled = true;
        speed = 3.03;
        bezier = "quick";
      }
      {
        leaf = "layers";
        enabled = true;
        speed = 3.81;
        bezier = "easeOutQuint";
      }
      {
        leaf = "layersIn";
        enabled = true;
        speed = 4;
        bezier = "easeOutQuint";
        style = "fade";
      }
      {
        leaf = "layersOut";
        enabled = true;
        speed = 1.5;
        bezier = "linear";
        style = "fade";
      }
      {
        leaf = "fadeLayersIn";
        enabled = true;
        speed = 1.79;
        bezier = "almostLinear";
      }
      {
        leaf = "fadeLayersOut";
        enabled = true;
        speed = 1.39;
        bezier = "almostLinear";
      }
      {
        leaf = "workspaces";
        enabled = true;
        speed = 1.94;
        bezier = "almostLinear";
        style = "fade";
      }
      {
        leaf = "workspacesIn";
        enabled = true;
        speed = 1.21;
        bezier = "almostLinear";
        style = "fade";
      }
      {
        leaf = "workspacesOut";
        enabled = true;
        speed = 1.94;
        bezier = "almostLinear";
        style = "fade";
      }
      {
        leaf = "zoomFactor";
        enabled = true;
        speed = 7;
        bezier = "quick";
      }
    ];
  };
}
