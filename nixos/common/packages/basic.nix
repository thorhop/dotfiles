{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ which wget file psmisc pv screen ];
}
