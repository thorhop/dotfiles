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
        
        ghcAws = hask : hask.ghcWithPackages (self : with self;
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
    in
  rec {
    ghc74Def = pkgs.haskellPackages_ghc742.ghcWithPackages (self : with self; 
          pseudoHaskellPlatform self ++
          [
            Agda

            criterion
            testFramework
            testFrameworkHunit
            testFrameworkQuickcheck2
            testFrameworkTh
            hspec
          ]);

    ghc74Aws = ghcAws pkgs.haskellPackages_ghc742;
    ghc76Aws = ghcAws pkgs.haskellPackages_ghc761;

    envGhc74Def = pkgs.myEnvFun {
      name = "ghc74-def";
      buildInputs = [ ghc74Def ];
    };

    envGhc74Aws = pkgs.myEnvFun {
      name = "ghc74-aws";
      buildInputs = [ ghc74Aws ];
    };

    envGhc76Aws = pkgs.myEnvFun {
      name = "ghc76-aws";
      buildInputs = [ ghc76Aws ];
    };

    envGhcHEADAws = pkgs.myEnvFun {
      name = "ghcHEAD-aws";
      buildInputs = [ (ghcAws pkgs.haskellPackages_ghcHEAD) ];
    };

    osxEnv = pkgs.buildEnv {
      name = "osx-env";
      paths = [ pkgs.nix ghc74Def envGhc74Aws envGhc76Aws envGhcHEADAws ];
    };
  };
}