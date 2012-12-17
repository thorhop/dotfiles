pkgs : {
  packageOverrides = pkgs : rec {
    ghc74Darwin = {
      all = pkgs.haskellPackages_ghc742.ghcWithPackages (self : with self; [
#          HTTP HUnit QuickCheck async cgi fgl
#          haskellSrc html network parallel parsec primitive
#          regexBase regexCompat regexPosix
#          split stm syb deepseq text transformers mtl vector xhtml zlib random
#          tar transformers
          cabalInstall alex happy ghc haddock
          cabalDev

          QuickCheck
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
      name = "env-ghc74-darwin";
      buildInputs = [ghc74Darwin];
    };
  };
}
