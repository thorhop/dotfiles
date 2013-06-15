# Edit this configuration file to define what should be installed on
# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  require =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/admin-aristid.nix
      ../common/packages/basic.nix
    ];

  boot.initrd.kernelModules =
    [ # Specify all kernel modules that are necessary for mounting the root
      # filesystem.
      # "xfs" "ata_piix"
    ];

  boot.initrd.luks.devices = [ { name = "euphemus-main"; device = "/dev/sda3"; preLVM = true; allowDiscards = true; } ];
    
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  boot.kernelPackages = pkgs.linuxPackages_3_9;

  networking.hostName = "euphemus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables Wireless.

  # Add filesystem entries for each partition that you want to see
  # mounted at boot time.  This should include at least the root
  # filesystem.

  # fileSystems."/".device = "/dev/disk/by-label/nixos";
  fileSystems."/".label = "euphemus-root";
  fileSystems."/boot".label = "euphemus-boot";
  fileSystems."/home".label = "euphemus-home";

  # fileSystems."/data" =     # where you want to mount the device
  #   { device = "/dev/sdb";  # the device
  #     fsType = "ext3";      # the type of the partition
  #     options = "data=journal";
  #   };

  # List swap partitions activated at boot time.
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
  #services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = false;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  environment.systemPackages = [];
}
