# This file defines how to build pokemon-icat using our flake inputs
{ lib, stdenv, rustPlatform, src, pokemon-icons-src }:

stdenv.mkDerivation rec {
  pname = "pokemon-icat";
  version = "1.2.0"; 

  inherit src;

  nativeBuildInputs = [ rustPlatform.cargoSetupHook cargo ];
  cargoVendorDir = "."; 


  buildPhase = ''
    runHook preBuild
    cargo build --release --locked
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    # Install the main binary
    install -Dm755 target/release/pokemon-icat $out/bin/pokemon-icat

    # Manually place the pokemon-icons data where the program expects it
    mkdir -p $out/share/pokemon-icons
    cp -r ${pokemon-icons-src}/* $out/share/pokemon-icons/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Shows any Pokémon sprite in your terminal!";
    homepage = "https://github.com/aflaag/pokemon-icat";
    license = licenses.gpl3Only;
    mainProgram = "pokemon-icat";
  };
}