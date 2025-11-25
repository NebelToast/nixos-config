{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-25.05"; # Pin to a specific stable release
    };

    nixpkgs-c5ae371.url = "github:nixos/nixpkgs/c5ae371f1a6a7fd27823bc500d9390b38c05fa55"; 
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };
    affinity-nix = {
       url = "github:mrshmllow/affinity-nix";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brrtfetch-src = {
      url = "github:ferrebarrat/brrtfetch/main";
      flake = false; # This is a non-flake repository
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pokemon-icat = {
     url = "github:NebelToast/pokemon-icat";
     inputs.nixpkgs.follows = "nixpkgs";
    };
    fsel = {
      url = "github:Mjoyufull/fsel/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    songfetch = {
      url = "github:fwtwoo/songfetch";
      flake = false;
    };
    Kaizen = {
      url = "github:serene-brew/Kaizen";
      flake = false;
    };
    dooit = {
      url = "github:dooit-org/dooit";
    };
    flake-utils.url = "github:numtide/flake-utils";

  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.UwU = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = [
          ./disko.nix
          ./configuration.nix
          ./hardware-configuration.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.disko.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs self; };

              # ----------------------
            };
            _module.args = { inherit inputs; };
          }
        ];
      };
      packages.${system} = {
        brrtfetch = pkgs.callPackage ./brrtfetch.nix { src = inputs.brrtfetch-src; };
        songfetch = pkgs.callPackage ./songfetch.nix { songfetch-src = inputs.songfetch; };
        kaizen = pkgs.callPackage ./kaizen.nix { src = inputs.Kaizen; };
      };
      formatter.${system} = pkgs.nixfmt-tree;
    };
}
