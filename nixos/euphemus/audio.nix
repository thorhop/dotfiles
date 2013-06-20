# vim: set expandtab:sw=2:sts=2:ai:

{ pkgs, config, ... }:

{
  environment.systemPackages = [ pkgs.pavucontrol ];

  hardware.pulseaudio =
    {
      enable = true;
      package = pkgs.pulseaudio.override {
        useSystemd = true;
        avahi = pkgs.avahi;
      };
    };

  sound.enableOSSEmulation = false;
}
