# vim: et:sw=2:sts=2:ai

{ config, pkgs, ... }:

let linPack = pkgs.linuxPackages_aristid; in
{
  require =
    [
      ./hardware-configuration.nix
      ./audio.nix
      ./editors.nix
      ./browsers.nix
      ../common/nix-cfg.nix
      ../common/admin-aristid.nix
      ../common/gnupg.nix
      ../common/packages/basic.nix
      ../common/packages/documentation.nix
      ../common/packages/version-control.nix
      ../common/packages/media.nix
      ../common/virt/vbox.nix
    ];

  boot.initrd.kernelModules =
    [ # Specify all kernel modules that are necessary for mounting the root
      # filesystem.
      # "xfs" "ata_piix"
    ];

  boot.initrd.luks =
    {
      devices =
        [
          { name = "euphemus-main"; device = "/dev/sda3"; preLVM = true; allowDiscards = true; }
        ];
      cryptoModules =
        [ "aes_x86_64" "cbc" "xts" "lrw" "sha256" "sha1" ];
    };

  boot.initrd.postMountCommands = ''
    cryptsetup luksOpen /dev/disk/by-uuid/3cf298f7-3dfb-4104-a2db-4aff6e04705c rustluks --key-file=/mnt-root/root/keys/luks1 &>/mnt-root/root/luks1.log
    lvm vgchange -ay spinner
    '';

  # Use the GRUB 2 boot loader.
  boot.loader.grub =
    {
      enable = true;
      version = 2;
      device = "/dev/sda";
      memtest86 = { enable = true; };
    };

  boot.kernelPackages = linPack;

  boot.kernelModules = [ "coretemp" "nct6775" ];

  boot.cleanTmpDir = true;

  networking.hostName = "euphemus"; # Define your hostname.

  networking.wireless.enable = true;  # Enables Wireless.

  fileSystems."/" = { label = "euphemus-root"; };
  fileSystems."/boot" = { label = "euphemus-boot"; };
  fileSystems."/home" = { label = "euphemus-home"; };
  fileSystems."/bulk" = { label = "patina"; };
  fileSystems."/tmp" = { device = "none"; fsType = "tmpfs"; };

  swapDevices =
    [ # { device = "/dev/disk/by-label/swap"; }
    ];

  hardware.bluetooth = { enable = true; };

  hardware.sane = { enable = true; };
  users.extraUsers.aristid.extraGroups = [ "scanner" ];

  i18n = {
     consoleFont = "lat9w-16";
     consoleKeyMap = "us";
     defaultLocale = "de_DE.UTF-8";
  };

  # List services that you want to enable:

  services.openssh = { enable = true; passwordAuthentication = false; };

  services.udisks2 = { enable = true; };

  services.locate = { enable = true; };

  services.rsnapshot =
    let pgBackup = pkgs.writeScript "pg_backup.sh" ''
    #!${pkgs.bash}/bin/bash
    umask 0077
    ${pkgs.su}/bin/su -s ${pkgs.bash}/bin/bash postgres -c '${pkgs.postgresql92}/bin/pg_dumpall -w -U postgres' | xz >pg_dump.sql.xz
    ${pkgs.coreutils}/bin/chmod 600 pg_dump.sql.xz
    '';
    in
    {
      enable = true;
      extraConfig = ''
snapshot_root	/bulk/snapshots/rsnapshot/
no_create_root	1

retain	hourly	24
retain	daily	7
retain	weekly	4
retain	monthly	240

logfile	/var/log/rsnapshot

sync_first	1

backup	/home/		localhost/
backup	/etc/		localhost/
backup_script	${pgBackup}	localhost/postgres/

# pluto
backup	root@pluto.aristid.net:/home/	pluto/	ssh_args=-i /root/keys/id_backup

# hermit
#backup	root@79.125.21.59:/home/	hermit/	ssh_args=-p 22023
#backup	root@79.125.21.59:/mnt/irc-vol/	hermit/	ssh_args=-p 22023
      '';
      cronIntervals = { sync = "10 * * * *";
                        hourly = "20 * * * *";
                        daily = "50 21 * * *";
                        weekly = "40 21 * * 6";
                        monthly = "30 21 1 * *"; };
    };

  services.cron = { enable = true; };

  services.avahi =
    {
      enable = true;
      nssmdns = true;
    };

  services.printing =
    {
      enable = true;
      drivers = with pkgs; [ hplip ghostscript gutenprint cups_pdf_filter ];
    };

  services.xserver =
    {
      enable = true;
      layout = "us";
      xkbVariant = "altgr-intl";
      xkbOptions = "eurosign:e, compose:menu";
      displayManager =
        {
          slim = { enable = true; defaultUser = "aristid"; };
          desktopManagerHandlesLidAndPower = false;
        };
      desktopManager =
        {
          xterm.enable = false;
          default = "none";
        };
    };

  hardware.opengl =
    {
      videoDrivers = [ "nvidia" "fbdev" ];
      driSupport32Bit = true;
    };

  services.dbus.packages = [ pkgs.gnome.GConf ];

  services.upower = { enable = true; };

  services.udev.extraRules = ''
    ATTR{address}=="d4:3d:7e:b8:94:c3", NAME="wired0"
    ATTR{address}=="00:0c:f6:e6:95:9b", NAME="wifi0"
    SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="users"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1004", MODE="0666", GROUP="users"
    '';

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql92;
  };

  fonts =
    {
      enableCoreFonts = true;
      enableGhostscriptFonts = true;
      extraFonts = with pkgs; [ dejavu_fonts inconsolata vistafonts lmodern unifont ];
    };

  programs.bash.enableCompletion = true;

  environment.systemPackages = with pkgs;
    [
      lm_sensors
      dmidecode
      mosh
      # desktop stuff
      xdg_utils
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
      # TODO: make proper haskell environments
      # also: C++ environments
      (haskellPackages.ghcWithPackagesOld (self : with self;
        [ xmonad xmonadContrib xmonadExtras
          haskellPlatform pipes pipesParse criterion either cryptohash lens cipherAes base64Bytestring
          binary dataBinaryIeee754 ] ))
      gnome.GConf
      gnucash
      skype
      evince
      unzip
      ncdu
      ncftp
      # libreoffice
      hplip
      xsane
      rsnapshot
      openssl
      cudatoolkit
      valgrind
      kde4.kcachegrind
      anki
      darcs
      R
      coq
      ctags
      imagemagick
      gdb
      sshuttle
      pwgen
      xlibs.xmodmap
      nmap
      iptables
      graphviz
      linPack.perf
      pythonFull
      fio
      llvm
      gdb
      gcc
      # nixops
      texLiveFull
    ];

  environment.pathsToLink = ["/share/doc" "/etc/gconf"];

  security.sudo.configFile = ''
    # %wheel ALL=(ALL) NOPASSWD:shutdown
    '';

  users.primaryUser = "aristid";
}
