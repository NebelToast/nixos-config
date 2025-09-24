{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.UwU = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };
      formatter.${system} = pkgs.nixfmt-tree;
    };
}
