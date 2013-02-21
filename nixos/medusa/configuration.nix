{ config, pkgs, ... }:

{
  require =
    [
      ./hardware-configuration.nix
      ../common/packages/basic.nix
      ../common/packages/browsers.nix
      ../common/packages/version-control.nix
      ../common/packages/editors.nix
      ../common/packages/media.nix
      ../common/packages/build.nix
      ../common/packages/networking.nix
      ../common/packages/math.nix
      ../common/packages/graphics.nix
      ../common/packages/misc.nix
      ../common/gnupg.nix
      ../common/admin-aristid.nix
      ../common/nix-cfg.nix
      ../common/keyboards.nix
      ../common/virt/vbox.nix
      ../common/virt/libvirtd.nix
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

  fileSystems."/".label = "medusa-root";
  fileSystems."/boot".label = "medusa-boot";
  fileSystems."/home".label = "medusa-home";
  fileSystems."/data".label = "medusa-data";
  fileSystems."/blobby".label = "medusa-blobby";

  swapDevices = [ { label = "medusa-swap"; }];

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
