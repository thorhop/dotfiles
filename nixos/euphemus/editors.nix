{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      emacs
      (vim_configurable.override { source = "latest"; })
      aspell
      aspellDicts.de
      aspellDicts.en
      aspellDicts.nl
    ];
}
