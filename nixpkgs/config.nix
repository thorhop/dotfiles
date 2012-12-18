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
    ghc74Darwin = {
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

    envGhc74Darwin = pkgs.myEnvFun {
      name = "ghc74-darwin";
      buildInputs = [ pkgs.stdenv ghc74Darwin.all ];
    };
  };
}
