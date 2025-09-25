{ config, lib, pkgs, ... }:
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
    wl-clipboard
    (pkgs.writeScriptBin "rofi-clipboard" "cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy")
    btop
    hyprpaper
    davinci-resolve
    brightnessctl
    (pkgs.writeScriptBin "wallchanger" ''
      #!${lib.getExe pkgs.python3}
      ${builtins.readFile ./wallchanger.py}
    '')
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  services.cliphist.enable = true;

  systemd.user.services.cliphist.Service.ExecStopPost =
    "${lib.getExe config.services.cliphist.package} wipe";

  # Merged GTK, QT, and Cursor configuration to fix duplicate definitions
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Open Sans";
      package = pkgs.open-sans;
    };
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
    platformTheme.name = "adwaita";
  };

  home.pointerCursor = {
    name = "Bibata-Original-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
  home.stateVersion = "25.05";
}
