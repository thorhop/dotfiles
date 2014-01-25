{ config, pkgs, ... }:

{
  # gnupg1 contains compat symlinks
  environment.systemPackages = [ pkgs.gnupg pkgs.gnupg1 ];

  services.xserver.startGnuPGAgent = true;
  services.xserver.startOpenSSHAgent = false;
}
