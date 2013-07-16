{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
                               [ mplayer
                                 mpg123
                                 lame
                                 abcde
                               ];
}
