
{ pkgs, src }:

pkgs.python3Packages.buildPythonApplication rec {
  pname = "songfetch";
  version = "unstable";
  format = "pyproject";

  src = src;

  nativeBuildInputs = [ pkgs.python3Packages.setuptools ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    pillow
    ascii-magic
  ];

  meta = with pkgs.lib; {
    description = "A command-line tool to fetch song information";
    homepage = "https://github.com/fwtwoo/songfetch";
    license = licenses.mit;
  };
}
