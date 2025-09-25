{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    theme = "${config.home.homeDirectory}/.config/rofi/themes/roficolors.rasi";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
    };
  };
}
