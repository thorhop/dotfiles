{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ iptables inetutils ];
}
