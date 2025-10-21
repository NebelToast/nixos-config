{ lib, buildGoModule, src }:

buildGoModule rec {
  pname = "kaizen";
  version = "unstable";

  inherit src;

  proxyVendor = true;
  vendorHash = "sha256-Ji9OQYRD1ywT45zyhDonEJXPWhHOTw3JedaqvgqPyGQ=";
  doCheck = false;

  meta = with lib; {
    description = "Why Watch Anime Like a Normie?";
    homepage = "https://github.com/serene-brew/Kaizen";
    license = licenses.mit;
  };
}
