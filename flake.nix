{
  description = "An over-engineered Hello World in bash";

  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
  };

  outputs = { self, nixpkgs}:
    let
      version = "0.0.1";
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });
    in
    {
      overlay = final: prev: {
        twofa = with final; stdenv.mkDerivation rec {
          name = "2fa-${version}";
          src = self;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          dontBuild = true;
          installPhase = "
            install -Dm755 2fa $out/bin/2fa
            patchShebangs $out/bin/2fa
            wrapProgram $out/bin/2fa --set PATH '${lib.makeBinPath [
                oath-toolkit
                gpg2
                which
              ]}'
          ";
          makeFlags = [ "PREFIX=$(out)" ];
        };

      };

      packages = forAllSystems (system:
        {
          inherit (nixpkgsFor.${system}) twofa;
        });
      defaultPackage = forAllSystems (system: self.packages.${system}.twofa);
    };
}
