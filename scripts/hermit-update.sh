#!/run/current-system/sw/bin/bash

set -e

echo 'CHANNEL UPDATE'
sudo -H nix-channel --update

echo 'NIXOS REBUILD'
sudo nixos-rebuild switch

echo 'USER UPDATE'
nix-env --set hermit-env
