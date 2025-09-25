{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    extraConfig = ''
      include ${config.home.homeDirectory}/.config/kitty/themes/kittycolors.conf
    '';
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 11;
    };
  };
}
