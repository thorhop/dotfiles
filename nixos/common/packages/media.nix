{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
                               [ mplayer
                                 mpg123
                                 vlc
                                 lame
                                 abcde
                               ];
}
