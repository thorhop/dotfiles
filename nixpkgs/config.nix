pkgs : {
  packageOverrides = pkgs :
    let pseudoHaskellPlatform = hask : with hask;
        if builtins.currentSystem == "x86_64-darwin" then
        [ HTTP HUnit QuickCheck async cgi fgl
          haskellSrc html network parallel parsec primitive
          regexBase regexCompat regexPosix
          split stm syb deepseq text transformers mtl vector xhtml zlib random
          cabalInstall alex happy ghc haddock ]
        else
        [ hask.haskellPlatform ];
    in
  rec {
    ghc74Def = {
      all = pkgs.haskellPackages_ghc742.ghcWithPackages (self : with self; 
          pseudoHaskellPlatform self ++
          [
            criterion
            testFramework
            testFrameworkHunit
            testFrameworkQuickcheck2
            testFrameworkTh
            hspec

            httpConduit
            attempt
            cryptohash
            xmlConduit
          ]);
    };

    ghc74Aws = pkgs.haskellPackages_ghc742.ghcWithPackages (self : with self;
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

    envGhc74Def = pkgs.myEnvFun {
      name = "ghc74-def";
      buildInputs = [ pkgs.stdenv ghc74Def.all ];
    };

    envGhc74Aws = pkgs.myEnvFun {
      name = "ghc74-aws";
      buildInputs = [ pkgs.stdenv ghc74Aws ];
    };

    osxEnv = pkgs.buildEnv {
      name = "osx-env";
      paths = [ pkgs.nix envGhc74Def envGhc74Aws ];
    };
  };
}
