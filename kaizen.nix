{ lib, buildGoModule, src }:

buildGoModule rec {
  pname = "kaizen";
  version = "unstable";

  inherit src;

  proxyVendor = true;
  vendorHash = "sha256-Vt1XKf9cNB/LQGc5pl0hATk1sSEFc37UmqTRevBmyb0=";
  doCheck = false;

  meta = with lib; {
    description = "Why Watch Anime Like a Normie?";
    homepage = "https://github.com/serene-brew/Kaizen";
    license = licenses.mit;
  };
}
