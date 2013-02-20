{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ ncdu powertop rzip ];
}
