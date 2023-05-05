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
          propagatedBuildInputs = [ prev.oath-toolkit prev.gnupg ];
          installPhase =
            ''
              mkdir -p $out/bin
              cp 2fa $out/bin/
            '';
        };

      };

      packages = forAllSystems (system:
        {
          inherit (nixpkgsFor.${system}) twofa;
        });
      defaultPackage = forAllSystems (system: self.packages.${system}.twofa);
    };
}
