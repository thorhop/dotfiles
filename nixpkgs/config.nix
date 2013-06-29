pkgs : {
  chromium = { enableGoogleTalkPlugin = true; };
  bup.par2Support = true;
  #pulseaudio = true;

  packageOverrides = pkgs :
    let haskellGen = import ./haskell.nix pkgs;
        haskell = haskellGen (pkgs.haskellPackages_ghc742);
        haskellGhc76 = haskellGen (pkgs.haskellPackages_ghc762);
    in
  rec {
    ftb = pkgs.callPackage ./packages/ftb.nix { };
    technicpack = pkgs.callPackage ./packages/technicpack.nix { };
    minecraftLauncher = pkgs.callPackage ./packages/minecraft-launcher.nix { };

    xtest = haskell.envGhcAws;

    osxEnv = pkgs.buildEnv {
      name = "osx-env";
      paths = with pkgs; [ haskell.ghcDef
                           haskell.envGhcAws
                           #haskellGhc76.envGhcDef
                           #haskellGhc76.envGhcAws
                           #haskell.envGhcStackage
                           bup ];
    };

    hermitEnv = pkgs.buildEnv {
      name = "hermit-env";
      paths = with pkgs; [ haskell.ghcDef
                           #haskell.envGhcAws
                           #haskellGhc76.envGhcAws
                           weechat
                           ncdu ];
    };

    medusaEnv = pkgs.buildEnv {
      name = "medusa-env";
      paths = with pkgs; [ keepassx
                           minecraft
                           ftb
                           technicpack
                           unetbootin
                           xmlstarlet
                           pavucontrol
                           llvm
                           haskell.ghcDef
                           haskell.envGhcAws
                           haskell.envGhcPlatform
                           #haskellGhc76.envGhcDef
                           haskellGhc76.envGhcAws
                           haskellGhc76.envGhcPlatform
                           #haskellGhc76.envGhcRepa
                           jre
                         ];
    };
  };
}
