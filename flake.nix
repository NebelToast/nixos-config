{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = {self, nixpkgs}: {nixosConfigurations.UwU = nixpkgs.lib.nixosSystem {modules = [./configuration.nix]};};
}