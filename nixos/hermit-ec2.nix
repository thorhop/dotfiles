{ config, pkgs, modulesPath, ... }:

let sshKeyFiles = [ ../ssh/mba_rsa.pub ../ssh/medusa_rsa.pub ]; in
{
  require = [ "${modulesPath}/virtualisation/amazon-image.nix"
              ./packages/basic.nix
              ./packages/browsers.nix
              ./packages/version-control.nix
              ./packages/editors.nix
            ];

  ec2.metadata = true;

  fileSystems = [ { mountPoint = "/mnt/irc-vol";
                    label = "irc-vol";
                  } ];

  swapDevices = [ { device = "/disk0/swapfile"; size = 1024; } ];

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
  networking.hostName = "hermit";
  networking.domain = "breitkreuz.me";

  security.sudo = { enable = true;
                    wheelNeedsPassword = false;
  		  };

  services.openssh = { enable = true;
                       passwordAuthentication = false;
                       ports = [ 22023 ];
  		     };

  services.locate = { enable = true; };

  environment.systemPackages = with pkgs;
                             [
                                jre
                                mosh
                                bup
                                python
                             ];
  environment.enableBashCompletion = true;

  nixpkgs.config = import ../nixpkgs/config.nix;
}
