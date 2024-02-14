{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in rec {
    packages.libfive = pkgs.libfive.overrideDerivation (old: {
          src = ./.;
    });

    legacyPackages = packages;

    defaultPackage = packages.libfive;

    devShell = pkgs.mkShell {
      buildInputs = [
        packages.libfive
        #(pkgs.python3.withPackages (python-pkgs: [
        #  (pkgs.python3.pkgs.toPythonModule (packages.libfive))
        #]))
      ];
    };
  });
}
