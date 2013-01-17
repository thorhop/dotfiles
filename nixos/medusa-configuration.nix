# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  require =
    [ # Include the results of the hardware scan.
      ./medusa-hardware-configuration.nix
    ];

  boot.initrd = { kernelModules =
                    [ "mac_hid" "hid_cherry" "hid_generic" "usbhid" "hid" "evdev" ];
                  luks.devices = [ { name = "cryptlvm"; device = "/dev/sda2"; preLVM = true; } ];
                };
    
  # Use the GRUB 2 boot loader.
  boot.loader.grub = { enable = true;
                       version = 2;
                       device = "/dev/sda";
                     };

  networking = { hostName = "medusa"; };

  fileSystems =
    [ { mountPoint = "/";
        label = "medusa-root"; }

      { mountPoint = "/boot";
        label = "medusa-boot"; }

      { mountPoint = "/home";
        label = "medusa-home"; }

      # { mountPoint = "/data"; # where you want to mount the device
      #   device = "/dev/sdb";  # the device
      #   fsType = "ext3";      # the type of the partition
      #   options = "data=journal";
      # }
    ];

  # List swap partitions activated at boot time.
  swapDevices =
    [ { label = "medusa-swap"; }
    ];

  time = { timeZone = "Europe/Berlin"; };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  services = { openssh = { enable = true; } ;
             };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  environment = { enableBashCompletion = true;
                  systemPackages = with pkgs; [ screen vim mosh git emacs file wget ]; };
}
