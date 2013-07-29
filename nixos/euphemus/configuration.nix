# vim: set expandtab:sw=2:sts=2:ai

{ config, pkgs, ... }:

{
  require =
    [
      ./hardware-configuration.nix
      ./audio.nix
      ./editors.nix
      ../common/nix-cfg.nix
      ../common/admin-aristid.nix
      ../common/gnupg.nix
      ../common/packages/basic.nix
      ../common/packages/documentation.nix
      ../common/packages/version-control.nix
      ../common/packages/media.nix
    ];

  boot.initrd.kernelModules =
    [ # Specify all kernel modules that are necessary for mounting the root
      # filesystem.
      # "xfs" "ata_piix"
    ];

  boot.initrd.luks.devices =
    [
      { name = "euphemus-main"; device = "/dev/sda3"; preLVM = true; allowDiscards = true; }
    ];
    
  # Use the GRUB 2 boot loader.
  boot.loader.grub =
    {
      enable = true;
      version = 2;
      device = "/dev/sda";
      memtest86 = true;
    };

  boot.kernelPackages = pkgs.linuxPackages_3_9;

  networking.hostName = "euphemus"; # Define your hostname.

  networking.wireless.enable = true;  # Enables Wireless.

  fileSystems."/" = { label = "euphemus-root"; };
  fileSystems."/boot" = { label = "euphemus-boot"; };
  fileSystems."/home" = { label = "euphemus-home"; };

  swapDevices =
    [ # { device = "/dev/disk/by-label/swap"; }
    ];

  hardware.bluetooth = { enable = true; };

  i18n = {
     consoleFont = "lat9w-16";
     consoleKeyMap = "us";
     defaultLocale = "de_DE.UTF-8";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = { enable = true; };

  services.locate = { enable = true; };

  # fcron
  services.fcron = { enable = true; };

  services.avahi =
    {
      enable = true;
      nssmdns = true;
    };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver =
    {
      enable = true;
      videoDrivers = [ "nvidia" "fbdev" ];
      driSupport32Bit = true;
      layout = "us";
      xkbVariant = "altgr-intl";
      xkbOptions = "eurosign:e, compose:menu";
      displayManager =
        {
          slim.enable = false;
          kdm.enable = true;
        };
      desktopManager =
        {
          xterm.enable = false;
          default = "none";
        };
    };

  services.dbus.packages = [ pkgs.gnome.GConf ];

  services.upower = { enable = true; };

  fonts =
    {
      enableCoreFonts = true;
      enableGhostscriptFonts = true;
      extraFonts = with pkgs; [ dejavu_fonts inconsolata vistafonts lmodern unifont ];
    };

  environment.enableBashCompletion = true;

  environment.systemPackages = with pkgs;
    [
      lm_sensors
      dmidecode
      mosh
      # desktop stuff
      dunst
      libnotify
      dropbox
      scrot
      trayer
      xlibs.xmessage
      haskellPackages.xmobar
      dropbox
      dropbox-cli
      keepassx
      rxvt_unicode
      xsel
      glxinfo
      xlibs.xdpyinfo
      lsof
      ltrace
      smartmontools
      xlibs.xclock
      gnumake
      (haskellPackages.ghcWithPackages (self : with self;
        [ xmonad xmonadContrib xmonadExtras
          haskellPlatform ] ))
      chromiumDevWrapper
      firefoxWrapper
      gnome.GConf
      gnucash
      skype
      evince
      duplicity
    ];

  environment.pathsToLink = ["/share/doc" "/etc/gconf"];
}
