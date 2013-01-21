{ config, pkgs, ... }:

{
  require =
    [
      ./medusa-hardware-configuration.nix
      ./packages/basic.nix
      ./packages/browsers.nix
      ./packages/version-control.nix
      ./packages/editors.nix
      ./packages/media.nix
      ./gnupg.nix
      ./admin-aristid.nix
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

  boot.kernelPackages = pkgs.linuxPackages_3_7;

  #boot.crashDump = { enable = true; };

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

  users.extraUsers.aristid.extraGroups = [ "audio" ];

  time = { timeZone = "Europe/Berlin"; };

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  hardware = { pulseaudio = { enable = true; }; };

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
               avahi = { enable = true;
                         nssmdns = true; };
               nixosManual = { showManual = true; };
             };

  powerManagement = { enable = true; };

  environment = { enableBashCompletion = true;
                  systemPackages = with pkgs; [
                    mosh
                    unzip
                    lm_sensors
                    manpages
                    posix_man_pages
                    texLiveFull
                  ];
                  pathsToLink = ["/share/doc"];
                };

  fonts = { enableCoreFonts = true;
            enableGhostscriptFonts = true; };

  nix = { useChroot = true;
          extraOptions = "build-cores = 4"; };

  nixpkgs = { config = import ../nixpkgs/config.nix; };
}
