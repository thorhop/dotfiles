{ config, pkgs, modulesPath, ... }:

let sshKeyFiles = [ ../ssh/mba_rsa.pub ]; in
{
  require = [ "${modulesPath}/virtualisation/amazon-image.nix" ];

  users.extraUsers = { root = { openssh.authorizedKeys.keyFiles = sshKeyFiles; };
  		       aristid = { createUser = true;
		       	       	   createHome = true;
				   description = "Aristid Breitkreuz";
				   group = "users";
				   extraGroups = [ "wheel" ];
				   home = "/home/aristid";
				   isSystemUser = false;
				   useDefaultShell = true;
				   openssh.authorizedKeys.keyFiles = sshKeyFiles;
		       	         };
		     };

  time.timeZone = "Europe/Berlin";
  networking.hostName = "hermit.breitkreuz.me";

  security.sudo = { enable = true;
  		    wheelNeedsPassword = false;
  		  };

  services.openssh = { enable = true;
  		       passwordAuthentication = false;
		       ports = [ 22023 ];
  		     };

  environment.systemPackages = with pkgs; [ screen jre emacs vim git ];
  environment.enableBashCompletion = true;
}
