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
    brightnessctl
    (python3Packages.buildPythonApplication {
  pname = "wallchanger";
  version = "2.7.9";
  pyproject = true;

  src = ./wallchanger.py;
  build-system = with pkgs.python3Packages; [ setuptools ];

  # dependencies = with python3Packages; [
  #   tornado
  #   python-daemon
  # ];

  # meta = {
  #   # ...
  # };
})
  ];
# Import all your modularized configurations

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.stateVersion = "25.05";
}
