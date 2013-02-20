{ config, pkgs, ... }:

{
  require = [ <nixos/modules/virtualisation/amazon-image.nix>
              ./common/packages/basic.nix
              ./common/packages/browsers.nix
              ./common/packages/version-control.nix
              ./common/packages/editors.nix
              ./common/admin-aristid.nix
              ./common/nix-cfg.nix
            ];

  ec2.metadata = true;

  fileSystems = [ { mountPoint = "/mnt/irc-vol";
                    label = "irc-vol";
                  } ];

  swapDevices = [ { device = "/disk0/swapfile"; size = 1024; } ];

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

  services.xserver = { enable = false; };

  environment.systemPackages = with pkgs;
                             [
                                jre
                                mosh
                                bup
                                python
                             ];
  environment.enableBashCompletion = true;
}
