{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
disko = {url = "github:nix-community/disko/latest"; inputs.nixpkgs.follows = "nixpkgs";};

  };
  outputs = {
    self,
    nixpkgs,
...
  }@inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.UwU = nixpkgs.lib.nixosSystem {
      specialArgs ={ inherit inputs self;};
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
      extraSpecialArgs = {inherit inputs self;};

            # ----------------------
          };
        }
      ];
    };
    formatter.${system} = pkgs.nixfmt-tree;
  };
}
