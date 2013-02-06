# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  require =
    [ # Include the results of the hardware scan.
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
      ../admin-aristid.nix
      ../nix-cfg.nix
      ../keyboards.nix
    ];

  boot.loader.grub = { enable = true;
                       version = 2;
                       device = "/dev/disk/by-id/usb-SanDisk_Extreme_AA011102120532557907-0:0";
                       memtest86 = true;
                     };

  boot.kernelPackages = pkgs.linuxPackages_3_7;

  fileSystems."/" = { label = "nixstick"; };

  networking.hostName = "nixstick";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;
}
