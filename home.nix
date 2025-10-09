{
  config,
  lib,
  pkgs,
  inputs,
  stable-pkgs,self,
  ...
}:

# # Use a 'let' block to define custom packages for better organization

let

  terminal-flow = pkgs.python3Packages.buildPythonApplication rec {
    pname = "terminal-flow";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "kestalkayden";
      repo = "terminal-flow";
      # This is the UPDATED commit hash
      rev = "b5423350531e4b1f57cd7d090581f67b4ec1b861";
      # This is the NEW sha256 for the updated commit
      sha256 = "sha256-CkrO2kYWddn1TjxAaL6rTAu+EWNCVe/iwkR977Kl4RI=";
    };

    format = "pyproject";

    nativeBuildInputs = with pkgs.python3Packages; [
      hatchling
      setuptools
    ];

    propagatedBuildInputs = [ ];

    meta = with pkgs.lib; {
      description = "A terminal-based workflow tool";
      homepage = "https://github.com/kestalkayden/terminal-flow";
      license = licenses.mit;
    };
  };

in

{
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
    nemo-with-extensions
    kitty
    ledfx
    steam-run
    gemini-cli
    geteduroam
    geteduroam-cli
    hyprshot
    stable-pkgs.jetbrains.pycharm-professional
    stable-pkgs.beatprints
    superfile
    pokemonsay
  
    fortune
    obs-studio
    fastfetch
inputs.pokemon-icat.packages.${pkgs.system}.default
    self.packages.${pkgs.system}.brrtfetch
    hyprpicker
    file

    vlc
    probe-rs-tools
    lolcat
    protonvpn-gui
    intel-gpu-tools
    waybar
    pavucontrol
    discord
    direnv
    nurl
    rofi
    wallust
    just
    cbonsai
    spotify
    cava
    cliphist
    wl-clipboard
    btop
    gimp
    hyprpaper
    davinci-resolve
    brightnessctl

    # Now you just refer to your custom package by name
    terminal-flow

    (pkgs.writeScriptBin "rofi-clipboard" "cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy")
    (pkgs.writeScriptBin "wallchanger" ''
      #!${lib.getExe pkgs.python3}
      ${builtins.readFile ./wallchanger.py}
    '')
  ];
home.sessionVariables.BROWSER = "zen-browser";
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
# xdg.mimeApps = {
#     enable = true;
#     associations.added = {
#       "application/pdf" = ["org.gnome.Evince.desktop"];
#     };
#     defaultApplications = {
#       "application/pdf" = ["org.gnome.Evince.desktop"];
#     };
#   };


xdg.mimeApps = {
  enable = true;

  # Sets the default application to open a file type
  defaultApplications = {
    "x-scheme-handler/http" = "zen-beta.desktop";
    "x-scheme-handler/https" = "zen-beta.desktop";
    "x-scheme-handler/chrome" = "zen-beta.desktop";
    "text/html" = "zen-beta.desktop";
    "application/x-extension-htm" = "zen-beta.desktop";
    "application/x-extension-html" = "zen-beta.desktop";
    "application/x-extension-shtml" = "zen-beta.desktop";
    "application/xhtml+xml" = "zen-beta.desktop";
    "application/x-extension-xhtml" = "zen-beta.desktop";
    "application/x-extension-xht" = "zen-beta.desktop";
    "application/pdf" = "app.zen_browser.zen.desktop";
    "image/jpeg" = "app.zen_browser.zen.desktop";
    "image/png" = "app.zen_browser.zen.desktop";

    "text/plain" = "code.desktop";
    "application/octet-stream" = "code.desktop";
    "text/x-c" = "code.desktop";

    "x-scheme-handler/discord-402572971681644545" = "discord-402572971681644545.desktop";
  };
  #   removedAssociations = {
  #   "application/pdf" = [ "gimp.desktop" ];
  # };

};
  services.cliphist.enable = true;

  systemd.user.services.cliphist.Service.ExecStopPost =
    "${lib.getExe config.services.cliphist.package} wipe";

  # This is the MERGED and corrected gtk block
  gtk = {
    enable = true;
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
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
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
