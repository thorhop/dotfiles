{ pkgs, config, ... }:

with builtins;

{
  require = [ ../primary-user.nix ];

  users.extraUsers = listToAttrs [ 
    { name = config.users.primaryUser;
      value = { extraGroups = [ "libvirt" ]; }; } ];

  users.extraGroups.libvirt = {};

  environment.systemPackages = [ pkgs.virtinst ];
  environment.x11Packages = [ pkgs.virtmanager ];

  virtualisation.libvirtd = { enable = true; };

  # does not currently work!
  security.polkit.permissions =
    ''
    [libvirt Management Access]
      Identity=unix-group:libvirt
      Action=org.libvirt.unix.manage
      ResultAny=yes
      ResultInactive=yes
      ResultActive=yes
    '';
}
