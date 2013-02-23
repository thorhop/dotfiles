{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      emacs
      vim
      aspell
      aspellDicts.de
      aspellDicts.en
      aspellDicts.nl
    ];
}
