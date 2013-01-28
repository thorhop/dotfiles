pkgs : hask :

rec {
  version = hask.ghcPlain.version;

  ghcDef = hask.ghcWithPackages (self : with self;
        [
          haskellPlatform
          Agda

          cryptohash
          base64Bytestring
          lens

          caseInsensitive

          criterion
          testFramework
          testFrameworkHunit
          testFrameworkQuickcheck2
          testFrameworkTh
          hspec
        ]);

  ghcAws = hask.ghcWithPackages (self : with self;
        [
          cabalInstall
          attempt
          base64Bytestring
          blazeBuilder
          caseInsensitive
          cereal
          conduit
          cryptoApi
          cryptohash
          httpConduit
          httpTypes
          liftedBase
          monadControl
          mtl
          resourcet
          utf8String
          xmlConduit
        ]);

  envGhcDef = pkgs.myEnvFun {
    name = "ghc-def-${version}";
    buildInputs = [ ghcDef ];
  };

  envGhcAws = pkgs.myEnvFun {
    name = "ghc-aws-${version}";
    buildInputs = [ ghcAws ];
  };

  envGhcStackage = pkgs.myEnvFun {
    name = "ghc-stackage-${version}";
    buildInputs = with hask;
                  [ (ghcWithPackages (self : [ self.Cabal_1_16_0_3 ]))
                    cabalInstall_1_16_0_2
                    cabalDev ];
  };
}