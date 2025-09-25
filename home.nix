{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nemo-with-extensions
    kitty
    waybar
    rofi
    just
    cbonsai
    spotify
    cava
    rofi
    cliphist
    btop
    hyprpaper
    davinci-resolve
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.stateVersion = "25.05";
}
