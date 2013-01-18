# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

let sshKeyFiles = [ ../ssh/mba_rsa.pub ]; in
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
                       memtest86 = true;
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

  users.extraUsers = { root = { openssh.authorizedKeys.keyFiles = sshKeyFiles; };
                       aristid = { createUser = true;
                                   createHome = true;
                                   description = "Aristid Breitkreuz";
                                   group = "users";
                                   extraGroups = [ "wheel" ];
                                   home = "/home/aristid";
                                   isSystemUser = false;
                                   useDefaultShell = true;
                                   openssh.authorizedKeys.keyFiles = sshKeyFiles; };
                     };

  time = { timeZone = "Europe/Berlin"; };

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  hardware = { pulseaudio = { enable = true; }; };

  security.sudo = { enable = true; };

  services = { openssh = { enable = true; };
               locate = { enable = true; };
               xserver = { enable = true;
                           layout = "us";
                           xkbVariant = "altgr-intl";
                           displayManager = { kdm.enable = true; };
                           desktopManager = { kde4.enable = true;
                                              xterm.enable = true; };
                         };
               printing = { enable = true; };
               nixosManual = { showManual = true; };
             };

  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  powerManagement = { enable = true; };

  environment = { enableBashCompletion = true;
                  systemPackages = with pkgs; [
                    which
                    wget
                    screen
                    vim
                    mosh
                    git
                    emacs
                    file
                    wget
                    pstree
                    chromiumWrapper
                    firefox
                    w3m
                  ];
                };

  fonts = { enableCoreFonts = true; };

  nix = { useChroot = true; };

  nixpkgs.config = import ../nixpkgs/config.nix;
}
