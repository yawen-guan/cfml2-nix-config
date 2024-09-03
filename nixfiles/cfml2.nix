# The nix recipe for cfml2.

{ lib, mkCoqDerivation, coq, ocaml, tlc, dune, findlib, pprint, menhir, bash }:
mkCoqDerivation {
  pname = "coq${coq.coq-version}-cfml2";
  namePrefix = [ ];
  displayVersion = { coq = false; };
  owner = "charguer";
  repo = "cfml2";
  version = "dev";
  src = builtins.fetchGit {
    url = "https://gitlab.inria.fr/charguer/cfml2.git";
    name = "cfml2";
    rev = "d68b6a2ea489e0ea240279f644f9943a7b7462ab";
    submodules = true;
  };
  buildInputs = [ bash ];
  propagatedBuildInputs = [ ocaml tlc dune findlib pprint menhir ];

  # Sometimes the shebang line (#!/usr/bin/env bash) might not be correctly
  # interpreted in the Nix environment. Use patchShebangs to ensure that the
  # script uses the correct interpreter.
  preConfigure = ''
    patchShebangs .
    substituteInPlace Makefile --replace "/bin/bash" "${bash}/bin/bash"

    # Comment out the unnecessary use of [cfml_config] in [cfmlc.ml], otherwise
    # the generated executable [cfmlc.exe] requires to be found in relative
    # path [./_build/generator/default/cfmlc.exe].
    sed -i '48,49s/^/(* /; 48,49s/$/ *)/' generator/cfmlc.ml
    sed -i '82,85s/^/(* /; 82,85s/$/ *)/' generator/cfmlc.ml
  '';

  buildPhase = ''
    make depend
    make -j all
  '';

  installPhase = let
    cfml = "$out/lib/coq/${coq.coq-version}/user-contrib/CFML/";
    cfml-stdlib = "$out/lib/coq/${coq.coq-version}/user-contrib/CFML/Stdlib/";
    cfmlc-exe = "$out/bin/cfmlc.exe";
    cfmlc-wrap = "$out/bin/cfmlc";
  in ''
    # Install cfml and stdlib as coq libraries.
    mkdir -p ${cfml} ${cfml-stdlib}
    cp -r lib/coq/. ${cfml}
    cp -r lib/stdlib/. ${cfml-stdlib}

    # Install cfmlc.exe.
    mkdir -p $out/bin
    cp -r _build/default/generator/cfmlc.exe ${cfmlc-exe}

    # Create a wrapper script for cfmlc.exe.
    cat > ${cfmlc-wrap} <<EOF
    #!/usr/bin/env bash
    exec ${cfmlc-exe} -I ${cfml-stdlib} "\$@"
    EOF
    chmod +x ${cfmlc-wrap}
  '';

  meta = {
    description =
      "CFML: a framework for interactive proofs of ML programs in Separation Logic";
    homepage = "http://www.chargueraud.org/softs/cfml/";
  };
}
