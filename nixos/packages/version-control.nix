{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ git subversion mercurial ];
}
