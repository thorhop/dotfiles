{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs;
    [
      imagemagick
      gimp
      #gimpPlugins
    ];
}