{ config, pkgs, ... }:

let sshKeyFiles = [ ../ssh/mba_rsa.pub ]; in
{
  require =
    [
      ./medusa-hardware-configuration.nix
    ];

  boot.initrd = { kernelModules =
                    [ "mac_hid"
                      "hid_cherry"
                      "hid_generic"
                      "usbhid"
                      "hid"
                      "evdev" ];

                  luks.devices = [ { name = "cryptlvm";
                                     device = "/dev/sda2";
                                     preLVM = true;
                                     allowDiscards = true; }
                                 ];
                };
    
  boot.loader.grub = { enable = true;
                       version = 2;
                       device = "/dev/sda";
                       memtest86 = true;
                     };

  boot.crashDump = { enable = true; };

  networking = { hostName = "medusa"; };

  fileSystems =
    [ { mountPoint = "/";
        label = "medusa-root"; }

      { mountPoint = "/boot";
        label = "medusa-boot"; }

      { mountPoint = "/home";
        label = "medusa-home"; }
    ];

  swapDevices =
    [ { label = "medusa-swap"; }
    ];

  users.extraUsers = { root = { openssh.authorizedKeys.keyFiles = sshKeyFiles; };
                       aristid = { createUser = true;
                                   createHome = true;
                                   description = "Aristid Breitkreuz";
                                   group = "users";
                                   extraGroups = [ "wheel" "audio" ];
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
                           desktopManager = { #kde4.enable = true;
                                              #xterm.enable = true;
                                              xfce.enable = true;
                                            };
                           windowManager = { xmonad.enable = true; };
                         };
               printing = { enable = true; };
               avahi = { enable = true; };
               nixosManual = { showManual = true; };
             };

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
                    psmisc
                    pv
                    unzip
                    lm_sensors
                    chromiumWrapper
                    firefox
                    w3m
                    mplayer
                  ];
                };

  fonts = { enableCoreFonts = true; };

  nix = { useChroot = true;
          extraOptions = "build-cores = 4"; };

  nixpkgs = { config = import ../nixpkgs/config.nix; };
}
