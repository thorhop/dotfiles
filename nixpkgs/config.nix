pkgs : {
  chromium = { enableGoogleTalkPlugin = true; };
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
                           #haskellGhc76.envGhcDef
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
                           haskell.envGhcPlatform
                           haskell.envGhcCabalDev
                           #haskellGhc76.envGhcDef
                           haskellGhc76.envGhcAws
                           haskellGhc76.envGhcPlatform
                           haskellGhc76.envGhcCabalDev
                           jre ];
    };
  };
}
