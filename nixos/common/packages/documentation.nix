# vim: set expandtab:sw=2:

{ config, pkgs, ...}:

{
  environment.systemPackages = with pkgs; [ manpages posix_man_pages ];
}
