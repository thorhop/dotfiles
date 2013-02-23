{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
                               [ bc units rLang gnuplot ];
}
