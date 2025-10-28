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
    inputs.zen-browser.packages.${pkgs.system}.default
    inputs.fsel.packages.${pkgs.system}.default

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
    rclone
    pokemonsay
    element-desktop
    playerctl
    fortune
    insomnia
    obs-studio
    fastfetch
    pgadmin4
    inputs.pokemon-icat.packages.${pkgs.system}.default
    self.packages.${pkgs.system}.brrtfetch
    hyprpicker
    file
    vlc
    ascii-image-converter
    probe-rs-tools
    postgresql
    lolcat
    protonvpn-gui
    wireshark
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
    #nix-shell /home/julius/.config/dooit/ --run "dooit"
    dooit
    ffmpeg
    mediainfo
    wirelesstools
    dooit-extras
mpv
    terminal-flow
    self.packages.${pkgs.system}.songfetch
    self.packages.${pkgs.system}.kaizen

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

  # xdg.mimeApps = {
  #   enable = true;

  #   # Sets the default application to open a file type
  #   defaultApplications = {
  #     "x-scheme-handler/http" = "zen-beta.desktop";
  #     "x-scheme-handler/https" = "zen-beta.desktop";
  #     "x-scheme-handler/chrome" = "zen-beta.desktop";
  #     "text/html" = "zen-beta.desktop";
  #     "application/x-extension-htm" = "zen-beta.desktop";
  #     "application/x-extension-html" = "zen-beta.desktop";
  #     "application/x-extension-shtml" = "zen-beta.desktop";
  #     "application/xhtml+xml" = "zen-beta.desktop";
  #     "application/x-extension-xhtml" = "zen-beta.desktop";
  #     "application/x-extension-xht" = "zen-beta.desktop";
  #     "application/pdf" = "app.zen_browser.zen.desktop";
  #     "image/jpeg" = "app.zen_browser.zen.desktop";
  #     "image/png" = "app.zen_browser.zen.desktop";

  #     "text/plain" = "code.desktop";
  #     "application/octet-stream" = "code.desktop";
  #     "text/x-c" = "code.desktop";

  #     "x-scheme-handler/discord-402572971681644545" = "discord-402572971681644545.desktop";
  #   };
  #   #   removedAssociations = {
  #   #   "application/pdf" = [ "gimp.desktop" ];
  #   # };

  # };
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
      matchBlocks = {
        "code.fbi.h-da.de".identityFile = "/home/julius/.ssh/id_ed25519";
        "github.com".identityFile = "/home/julius/.ssh/id_ed25519";
        "192.168.1.249" = {
          identityFile = "/home/julius/.ssh/id_rsa_pi";
          user = "nebeltoast";
          };
      };
    };
  };

  # In your home.nix
  programs.neovim = {
    enable = true;
    # ... other neovim settings you might have ...

    # This is the crucial part!
    # It makes sure that the tools treesitter needs are available in Neovim's environment.
    extraPackages = with pkgs; [
      gcc # The C compiler needed to build parsers
      tree-sitter # The tree-sitter CLI tool
      git # Often used to fetch parsers
    ];
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
