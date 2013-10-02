{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ chromiumWrapper firefoxWrapper w3m ];
}
