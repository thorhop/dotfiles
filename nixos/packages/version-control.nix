{ config, pkgs, ... }:

let myGit = if config.services.xserver.enable then pkgs.gitFull else pkgs.gitSVN; in
{
  environment.systemPackages = with pkgs; [ myGit subversion mercurial ];
}
