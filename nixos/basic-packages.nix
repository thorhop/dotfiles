{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ which wget file pstree psmisc pv screen ];
}
