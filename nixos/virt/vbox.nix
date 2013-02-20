{ pkgs, config, ... }:

with builtins;

{
  require = [ <nixos/modules/programs/virtualbox.nix>
              ../primary-user.nix ];
  users.extraUsers = listToAttrs
   [ { name = config.users.primaryUser;
       value = { extraGroups = [ "vboxusers" ]; }; } ];
}
