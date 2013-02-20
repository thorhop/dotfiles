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
      ../common/packages/misc.nix
      ../common/admin-aristid.nix
      ../common/nix-cfg.nix
      ../common/keyboards.nix
    ];

  boot.loader.grub = { enable = true;
                       version = 2;
                       device = "/dev/disk/by-id/usb-SanDisk_Extreme_AA011102120532557907-0:0";
                       memtest86 = true;
                     };

  boot.kernelPackages = pkgs.linuxPackages_3_7;

  fileSystems."/" = { label = "nixstick"; };

  networking.hostName = "nixstick";

  time.timeZone = "Europe/Berlin";

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "de_DE.UTF-8";
  };

  services.openssh = { enable = true; };
  services.xserver = { enable = true;
                       layout = "us";
                       xkbVariant = "altgr-intl";
                       displayManager = { kdm.enable = true; };
                       desktopManager = { xfce.enable = true; };
                     };
  services.avahi = { enable = true;
                     nssmdns = true;
                   };
  services.nixosManual.showManual = true;

  powerManagement = { enable = true; };

  environment.enableBashCompletion = true;

  environment.systemPackages = with pkgs; [ mosh evince ];
  environment.pathsToLink = ["/share/doc"];

  fonts = { enableCoreFonts = true;
            enableGhostscriptFonts = true;
            extraFonts = with pkgs; [ dejavu_fonts inconsolata vistafonts lmodern unifont ]; };
}
