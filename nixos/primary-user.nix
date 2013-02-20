{ pkgs, config, ...}:

with pkgs.lib;

{
  options = {
    users.primaryUser = mkOption {
      description = ''
        Primary system user, all important rights enabled
      '';
    };
  };
}
