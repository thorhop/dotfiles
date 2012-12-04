{ config, pkgs, modulesPath, ... }:

let sshKeyFiles = [ ../ssh/mba_rsa.pub ]; in
{
  require = [ "${modulesPath}/virtualisation/amazon-image.nix" ];

  users.extraUsers = { root = { openssh.authorizedKeys.keyFiles = sshKeyFiles; }; };

  time.timeZone = "Europe/Berlin";

  services.openssh = { enable = true;
  		       passwordAuthentication = false;
		       permitRootLogin = "without-password";
		       #ports = [ 22 ];
  		     };

  environment.systemPackages = with pkgs; [ screen jre emacs vim ];
  environment.enableBashCompletion = true;
}
