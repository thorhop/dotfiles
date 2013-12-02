{ config, pkgs, ... }:

{
  nix = { useChroot = true;
          readOnlyStore = true;
          extraOptions = ''
            build-cores = 0
            gc-keep-outputs = true
            gc-keep-derivations = true
          ''; };

  nixpkgs = { config = import ../../nixpkgs/config.nix; };
}
