{
  description = "A nix-flake-based development environment with cfml2";

  inputs = {
    # nixpkgs with ocaml 4.14.1
    nixpkgs.url =
      "github:NixOS/nixpkgs/c407032be28ca2236f45c49cfb2b8b3885294f7f";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems
        (system: f { pkgs = import nixpkgs { inherit system; }; });
    in {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = let
            lib = pkgs.lib;
            mkCoqDerivation = pkgs.coqPackages.mkCoqDerivation;
            coq = pkgs.coq_8_18;
            ocaml = pkgs.ocaml;
            tlc =
              import ./nixfiles/tlc.nix { inherit lib mkCoqDerivation coq; };
            cfml2 = import ./nixfiles/cfml2.nix {
              inherit lib mkCoqDerivation coq ocaml tlc;
              dune = pkgs.ocamlPackages.dune_3;
              findlib = pkgs.ocamlPackages.findlib;
              pprint = pkgs.ocamlPackages.pprint;
              menhir = pkgs.ocamlPackages.menhir;
              bash = pkgs.bash;
            };
          in [ tlc cfml2 ] ++ (with pkgs; [ coq_8_18 ocaml ocamlformat ]);
        };
      });
    };
}
