{ config, pkgs, modulesPath, ... }:

{
  require = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  environment.systemPackages = with pkgs; [ screen jre emacs vim ];
  
}
