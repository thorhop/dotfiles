{ config, pkgs, ... }:

{
  require =
    [
      ./hardware-configuration.nix
      ../packages/basic.nix
      ../packages/browsers.nix
      ../packages/version-control.nix
      ../packages/editors.nix
      ../packages/media.nix
      ../packages/build.nix
      ../packages/networking.nix
      ../packages/math.nix
      ../packages/misc.nix
      ../gnupg.nix
      ../admin-aristid.nix
      ../nix-cfg.nix
      ../keyboards.nix
      ../virt/vbox.nix
      ../virt/libvirtd.nix
    ];

  boot.initrd.luks.devices = [ { name = "cryptlvm";
                                 device = "/dev/sda2";
                                 preLVM = true;
                                 allowDiscards = true; }
                             ];
    
  boot.loader.grub = { enable = true;
                       version = 2;
                       device = "/dev/sda";
                       memtest86 = true;
                     };

  boot.kernelPackages = pkgs.linuxPackages_3_7;
  boot.blacklistedKernelModules = [ "snd_hda_intel" ];

  #boot.crashDump = { enable = true; };

  networking = { hostName = "medusa"; };

  fileSystems =
    [ { mountPoint = "/";
        label = "medusa-root"; }

      { mountPoint = "/boot";
        label = "medusa-boot"; }

      { mountPoint = "/home";
        label = "medusa-home"; }

      { mountPoint = "/data";
        label = "medusa-data"; }

      { mountPoint = "/blobby";
        label = "medusa-blobby"; }
    ];

  swapDevices =
    [ { label = "medusa-swap"; }
    ];

  users.primaryUser = "aristid";

  users.extraUsers.aristid.extraGroups = [ "audio" ];

  time = { timeZone = "Europe/Berlin"; };

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "de_DE.UTF-8";
  };

  hardware = { pulseaudio = { enable = false; };
               sane = { enable = true; }; };

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
                           driSupport32Bit = true;
                         };
               printing = { enable = true;
                            drivers = with pkgs; [ hplip gutenprint cups_pdf_filter ]; };
               avahi = { enable = true;
                         nssmdns = true; };
               nixosManual = { showManual = true; };
               dbus.packages = [ pkgs.gnome.GConf ];
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
                    libreoffice
                    skype
                    gnucash
                    evince
                    adobeReader
                    xsane
                    hplip
                    dropbox
                    pythonFull
                    pydb
                  ];
                  pathsToLink = ["/share/doc" "/etc/gconf"];
                  etc = [ { source = ../../screenrc; target = "screenrc"; } ];
                };

  fonts = { enableCoreFonts = true;
            enableGhostscriptFonts = true;
            extraFonts = with pkgs; [ dejavu_fonts inconsolata vistafonts lmodern unifont ]; };
}
