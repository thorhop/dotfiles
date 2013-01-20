{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ w3m elinks ];
  environment.x11Packages = with pkgs; [ chromiumWrapper firefoxWrapper ];
}
