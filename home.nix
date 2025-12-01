{
  config,
  lib,
  pkgs,
  inputs,
  stable-pkgs,
  self,
  ...
}:

let
  pkgs-c5ae371 = import inputs.nixpkgs-c5ae371 {
    inherit (pkgs.stdenv.hostPlatform) system;
    config = pkgs.config;
  };
  terminal-flow = pkgs.python3Packages.buildPythonApplication rec {
    pname = "terminal-flow";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "kestalkayden";
      repo = "terminal-flow";
      rev = "b5423350531e4b1f57cd7d090581f67b4ec1b861";
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
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.fsel.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.affinity-nix.packages.x86_64-linux.v3
    nemo-with-extensions
    kitty
    yazi
    stable-pkgs.ledfx
    steam-run
    gemini-cli
    geteduroam
    geteduroam-cli
    hyprshot
    stable-pkgs.jetbrains.pycharm-professional
    stable-pkgs.beatprints
    superfile
    rclone
    pokemonsay
    element-desktop
    playerctl
    fortune
    insomnia
    obs-studio
    pkgs-c5ae371.winboat
    fastfetch
    inputs.pokemon-icat.packages.${pkgs.stdenv.hostPlatform.system}.default
    self.packages.${pkgs.stdenv.hostPlatform.system}.brrtfetch
    hyprpicker
    file
    vlc
    ascii-image-converter
    probe-rs-tools
    postgresql
    lolcat
    wireshark
    bandwhich
    asciinema
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
    powertop
    powerstat
    jetbrains.clion
    cava
    cliphist
    wl-clipboard
    btop
    gimp
    cmatrix
    hyprpaper
    davinci-resolve
    brightnessctl
    ffmpeg
    mediainfo
    gitfetch
    rsync
    wirelesstools
    mpv
    terminal-flow
    self.packages.${pkgs.stdenv.hostPlatform.system}.songfetch
    self.packages.${pkgs.stdenv.hostPlatform.system}.kaizen

    (pkgs.writeScriptBin "rofi-clipboard" "cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy")
    (pkgs.writeScriptBin "wallchanger" ''
      #!${lib.getExe pkgs.python3}
      ${builtins.readFile ./wallchanger.py}
    '')
  ];
  home.sessionVariables.BROWSER = "zen";
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  programs = {
    git = {
      enable = true;

      settings = {
        user = {
          name = "NebelToast";
          email = "juliussteude@gmail.com";
        };
        init.defaultBranch = "main";
      };

      signing = {
        format = "ssh";
        key = "/home/julius/.ssh/id_ed25519";
        signByDefault = true;
      };

      includes = [
        {
          condition = "gitdir:/home/julius/Uni/**";
          contents = {
            user = {
              name = "Julius Steude";
              email = "julius.steude@stud.h-da.de";
              signingkey = "/home/julius/.ssh/id_ed25519";
            };
          };
        }
      ];
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "code.fbi.h-da.de".identityFile = "/home/julius/.ssh/id_ed25519";
        "github.com".identityFile = "/home/julius/.ssh/id_ed25519";
        "pi" = {
          hostname = "192.168.1.249";
          identityFile = "/home/julius/.ssh/id_rsa_pi";
          user = "nebeltoast";
        };
      };
    };
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      gcc
      tree-sitter
      git
    ];
  };
  services.cliphist.enable = true;

  systemd.user.services.cliphist.Service.ExecStopPost =
    "${lib.getExe config.services.cliphist.package} wipe";

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
