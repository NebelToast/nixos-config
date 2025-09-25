{ config,lib, pkgs, ... }:
{
  # test
  home.packages = with pkgs; [

    nemo-with-extensions
    kitty
    waybar
    direnv
    rofi
    wallust
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


      gtk = {
        enable = true;
        gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        theme.package = pkgs.gnome-themes-extra;
        iconTheme.package = pkgs.papirus-icon-theme;
        font = {
          name = "Open Sans";
          package = pkgs.open-sans;
        };
      };
      qt = {
        enable = true;
        style.package = pkgs.adwaita-qt;
        platformTheme.name = "adwaita";
      };
      home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        size = 24;
      };
    


      gtk = {
        theme.name = "Adwaita-dark";
        iconTheme.name = "Papirus-Dark";
      };
      qt.style.name = "adwaita-dark";
      home.pointerCursor.name = "Bibata-Original-Classic";
    
programs.direnv = {
  enable = true;
  nix-direnv.enable = true;
  silent = true;
};
  home.stateVersion = "25.05";
}
