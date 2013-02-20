{ config, pkgs, ... }:

{
  nix = { useChroot = true;
          readOnlyStore = true;
          extraOptions = "build-cores = 0"; };

  nixpkgs = { config = import ../../nixpkgs/config.nix; };
}
