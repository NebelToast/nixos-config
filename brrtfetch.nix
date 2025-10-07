# Change the function arguments to accept `src` directly
{
  lib,
  stdenv,
  go,
  src,
}:

stdenv.mkDerivation rec {
  pname = "brrtfetch";
  version = "unstable";

  # Remove the fetchFromGitHub block and just use the provided `src`
  inherit src;

  nativeBuildInputs = [ go ];

  buildPhase = ''
    export GOCACHE=$TMPDIR/go-cache
    go build -o brrtfetch ./go/main.go
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp brrtfetch $out/bin/
  '';

  meta = {
    description = "Render animated ASCII art from a GIF for your sysinfo fetcher of choice";
    homepage = "https://github.com/ferrebarrat/brrtfetch";
    license = lib.licenses.mit;
    mainProgram = "brrtfetch";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
}
