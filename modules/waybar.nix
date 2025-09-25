{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    style = ''
      /* Import dynamic colors first */
      @import "${config.home.homeDirectory}/.config/waybar/waybar.css";

      /* Add any static, non-color styles below */
      #cpu, #memory, #temperature, #battery, #clock, #pulseaudio, #network, #bluetooth {
          padding: 0 10px;
          margin: 0 4px;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        "modules-left" = [ "hyprland/workspaces" ];
        "modules-center" = [ "hyprland/window" ];
        "modules-right" = [ "pulseaudio" "network" "cpu" "memory" "battery" "clock" ];

        "hyprland/workspaces" = {
          "on-scroll-up" = "hyprctl dispatch workspace e+1";
          "on-scroll-down" = "hyprctl dispatch workspace e-1";
          "format-icons" = {
            urgent = "";
            focused = "";
            default = "";
          };
        };
        "hyprland/window" = {
            "format" = "➡ {}";
            "separate-outputs" = true;
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          "format-muted" = "";
          "format-icons" = {
            headphone = "";
            default = [ "" "" "" ];
          };
          "on-click" = "pavucontrol";
        };
        network = {
          "format-wifi" = " {essid} ({signalStrength}%)";
          "format-ethernet" = " {ipaddr}/{cidr}";
          "format-disconnected" = "⚠ Disconnected";
        };
        cpu = { "format" = " {usage}%"; };
        memory = { "format" = "{}% "; };
        battery = {
          "states" = {
            warning = 30;
            critical = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-icons" = [ "" "" "" "" "" ];
        };
        clock = { "format" = "{:%H:%M}"; };
      };
    };
  };
}
