{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.gnupg ];

  services.xserver.startGnuPGAgent = true;
  services.xserver.startOpenSSHAgent = false;
}
