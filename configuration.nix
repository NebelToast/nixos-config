# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  stable-pkgs = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config = config.nixpkgs.config;
    overlays = [
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (python-final: python-prev: {
            pylette = python-prev.pylette.overridePythonAttrs (old: {
              doCheck = false;
            });
          })
        ];
      })
    ];
  };
  pkgs-c5ae371 = import inputs.nixpkgs-c5ae371 {
    system = pkgs.stdenv.hostPlatform.system;
    config = config.nixpkgs.config;
  };
  dooit-custom = let
    python = pkgs.python3;
    sitePackages = python.sitePackages;
    dooitPkg = inputs.dooit.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in pkgs.writeShellScriptBin "dooit" ''
    export PYTHONPATH="${pkgs.dooit-extras}/${sitePackages}:$PYTHONPATH"
    exec ${dooitPkg}/bin/dooit "$@"
  '';
in

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth.enable = true;
    loader.timeout = 0;
    kernelParams = [
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    consoleLogLevel = 3;
  };

  services.thermald.enable = false;
  services.power-profiles-daemon.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = [
      stable-pkgs.intel-compute-runtime
      stable-pkgs.rocmPackages.clr.icd
      stable-pkgs.intel-media-driver
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    fira-code
    font-awesome
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.hack
    nerd-fonts.ubuntu
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  services.udev.packages = [ pkgs.probe-rs-tools ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "UwU"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  programs.git.enable = true;
  services.flatpak.enable = true;
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  programs.fish.enable = true;
  programs.wireshark.enable = true;
  programs.zoxide.enable = true;
  programs.nh.enable = true;
  services.blueman.enable = true;
  programs.steam.enable = true;
  home-manager.extraSpecialArgs = { inherit stable-pkgs; };
  home-manager.users.julius = ./home.nix;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
    auto-optimise-store = true;
  };
  networking.networkmanager.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session.command =
        let
          sessionData = config.services.displayManager.sessionData.desktops;
        in
        lib.concatStringsSep " " [
          (lib.getExe pkgs.tuigreet)
          "--time"
          "--asterisks"
          "--remember"
          "--remember-user-session"
          "--sessions '${sessionData}/share/wayland-sessions:${sessionData}/share/xsessions'"
        ];
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInputs = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  console.keyMap = "de";
  services.printing.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.julius = {
    isNormalUser = true;
    description = "julius";
    extraGroups = [
      "networkmanager"
      "wheel"
      "wireshark"
      config.users.groups.docker.name
    ];
    shell = pkgs.fish;
  };

  virtualisation.docker.enable = true;

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vscode-fhs
    obsidian
    docker-compose
    freerdp
    pkgs-c5ae371.winboat
    dooit-custom
    #inputs.winboat.packages.${pkgs.system}.winboat
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
