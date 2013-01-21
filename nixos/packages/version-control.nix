{ config, pkgs, ... }:

let myGit = if config.services.xserver.enable then pkgs.gitFull else pkgs.gitSvn; in
{
  environment.systemPackages = with pkgs; [ myGit subversion mercurial ];
}
