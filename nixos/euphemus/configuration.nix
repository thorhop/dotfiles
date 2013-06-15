# vim: set expandtab:sw=2:sts=2:

{ config, pkgs, ... }:

{
  require =
    [
      ./hardware-configuration.nix
      ../common/admin-aristid.nix
      ../common/packages/basic.nix
      ../common/packages/documentation.nix
      ../common/packages/editors.nix
      ../common/packages/version-control.nix
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
    };

  boot.kernelPackages = pkgs.linuxPackages_3_9;

  networking.hostName = "euphemus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables Wireless.

  fileSystems."/" = { label = "euphemus-root"; };
  fileSystems."/boot" = { label = "euphemus-boot"; };
  fileSystems."/home" = { label = "euphemus-home"; };

  swapDevices =
    [ # { device = "/dev/disk/by-label/swap"; }
    ];

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = { enable = true; };

  # fcron
  services.fcron = { enable = true; };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver =
    {
      enable = true;
      layout = "us";
      xkbVariant = "altgr-intl";
      xkbOptions = "eurosign:e";
      desktopManager =
        {
          xterm.enable = true;
          #default = "none";
        };
    };

  environment.enableBashCompletion = true;

  environment.systemPackages = with pkgs;
    [
      lm_sensors
      dmidecode
    ];
}
