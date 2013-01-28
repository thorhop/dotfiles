pkgs : {
  bup.par2Support = true;
  #pulseaudio = true;

  packageOverrides = pkgs :
    let haskellGen = import ./haskell.nix pkgs;
        haskell = haskellGen (pkgs.haskellPackages_ghc742);
        haskellGhc76 = haskellGen (pkgs.haskellPackages_ghc761);
    in
  rec {
    ftb = pkgs.callPackage ./packages/ftb.nix { };

    osxEnv = pkgs.buildEnv {
      name = "osx-env";
      paths = with pkgs; [ haskell.ghcDef
                           haskell.envGhcAws
                           haskellGhc76.envGhcAws
                           haskell.envGhcStackage
                           bup ];
    };

    hermitEnv = pkgs.buildEnv {
      name = "hermit-env";
      paths = with pkgs; [ haskell.ghcDef
                           haskell.envGhcAws
                           haskellGhc76.envGhcAws
                           weechat
                           ncdu ];
    };

    medusaEnv = pkgs.buildEnv {
      name = "medusa-env";
      paths = with pkgs; [ dropbox
                           keepassx
                           minecraft
                           unetbootin
                           xmlstarlet
                           pavucontrol
                           haskell.ghcDef
                           haskell.envGhcAws
                           haskellGhc76.envGhcAws
                           jre ];
    };
  };
}
