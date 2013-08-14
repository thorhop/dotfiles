{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ chromiumDevWrapper firefoxWrapper w3m ];
}
