# The nix recipe for tlc.
# Reference: https://github.com/NixOS/nixpkgs/blob/0e4209dd43baaa8469cba3c6d366b5481d3f8af5/pkgs/development/coq-modules/tlc/default.nix

{ lib, mkCoqDerivation, coq }:
mkCoqDerivation {
  pname = "coq${coq.coq-version}-tlc";
  namePrefix = [ ];
  displayVersion = { coq = false; };
  owner = "charguer";
  repo = "tlc";
  version = "20240209";
  release."20240209".sha256 =
    "sha256-SZO4TXssy2xx478GutYU29hBbim6eca13eDSHfE6Fi0=";
  releaseRev = v: "${v}";
  buildInputs = [ ];
  propagatedBuildInputs = [ ];
  makeFlags = [ "CONTRIB=$(out)/lib/coq/${coq.coq-version}/user-contrib" ];
  meta = with lib; {
    homepage = "http://www.chargueraud.org/softs/tlc/";
    description = "Non-constructive library for Coq";
    license = licenses.free;
  };
}
