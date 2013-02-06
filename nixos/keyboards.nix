{ config, pkgs, ... }:

{
  boot.initrd.kernelModules =
    [
      "mac_hid"
      "hid_cherry"
      "hid_generic"
      "usbhid"
      "hid"
      "evdev"
    ];
}
