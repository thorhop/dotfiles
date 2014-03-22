pkgs : {
  vim = { ruby = false; };
  chromium = { enableAdobeFlash = true; enableGoogleTalkPlugin = true; };
  bup.par2Support = true;
  #pulseaudio = true;

  packageOverrides = pkgs :
    let haskellGen = import ./haskell.nix pkgs;
        haskell = haskellGen (pkgs.haskellPackages_ghc742);
        haskellGhc76 = haskellGen (pkgs.haskellPackages_ghc762);
    in
  rec {
    bluez = pkgs.bluez5;

    ftb = pkgs.callPackage ./packages/ftb.nix { };
    technicpack = pkgs.callPackage ./packages/technicpack.nix { };
    minecraftLauncher = pkgs.callPackage ./packages/minecraft-launcher.nix { };

    config.cabal.libraryProfiling = true;

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

    linuxPackages_aristid = pkgs.linuxPackagesFor linux_aristid linuxPackages_aristid;

    linux_aristid = pkgs.linux_3_13.override {
      extraConfig = ''
      '';
      kernelPatches = [
        # pkgs.kernelPatches.sec_perm_2_6_24
        # logitech_hid_dj_fix
        btusb_bcm_belkin
      ];
    };

    logitech_hid_dj_fix = {
      name = "logitech_hid_dj_fix";
      patch = ./patches/logitech_hid_dj_fix.patch;
    };

    btusb_bcm_belkin = {
      name = "btusb_bcm_belkin";
      patch = ./patches/btusb.patch;
    };
  };
}
