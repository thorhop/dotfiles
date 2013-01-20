{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ w3m ];
  environment.x11Packages = with pkgs; [ chromiumWrapper firefoxWrapper ];
}
