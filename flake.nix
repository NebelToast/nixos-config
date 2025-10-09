{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-25.05"; # Pin to a specific stable release
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:NebelToast/pokemon-icat/patch-1";
inputs.nixpkgs.follows = "nixpkgs";
    };
    fsel = {
      url ="github:Mjoyufull/fsel/main";
  inputs.nixpkgs.follows = "nixpkgs";
    };

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
      packages.${system}.brrtfetch = pkgs.callPackage ./brrtfetch.nix {src = inputs.brrtfetch-src;};
      formatter.${system} = pkgs.nixfmt-tree;
    };
}
