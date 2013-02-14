pkgs : hask :

rec {
  version = hask.ghcPlain.version;

  ghcPlatform = hask.ghcWithPackages (self : [ self.haskellPlatform ]);

  ghcDef = hask.ghcWithPackages (self : with self;
        [
          haskellPlatform
          Agda

          cabalDev
          ghcCore

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

  ghcCabalDev = hask.ghcWithPackages (self : with self; [ haskellPlatform MonadRandom setenv tar testFramework testFrameworkHunit ]);

  ghcRepa = hask.ghcWithPackages ( self : with self;
        [
          haskellPlatform
          repa
        ]);

  envGhcPlatform = pkgs.myEnvFun {
    name = "ghc-platform-${version}";
    buildInputs = [ ghcPlatform pkgs.llvm ];
  };

  envGhcDef = pkgs.myEnvFun {
    name = "ghc-def-${version}";
    buildInputs = [ ghcDef pkgs.llvm ];
  };

  envGhcAws = pkgs.myEnvFun {
    name = "ghc-aws-${version}";
    buildInputs = [ ghcAws pkgs.llvm ];
  };

  envGhcCabalDev = pkgs.myEnvFun {
    name = "ghc-cabal-dev-${version}";
    buildInputs = [ ghcCabalDev pkgs.llvm ];
  };

  envGhcStackage = pkgs.myEnvFun {
    name = "ghc-stackage-${version}";
    buildInputs = with hask;
                  [ (ghcWithPackages (self : [ self.Cabal_1_16_0_3 ]))
                    cabalInstall_1_16_0_2
                    cabalDev ];
  };

  envGhcRepa = pkgs.myEnvFun {
    name = "ghc-repa-${version}";
    buildInputs = [ ghcRepa pkgs.llvm ];
  };
}
