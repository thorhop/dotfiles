{ config, ... }:

let sshKeyFiles = [ ../../ssh/mba_rsa.pub
                    ../../ssh/medusa_rsa.pub
                    ../../ssh/nixstick.pub ]; in
{
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

  security.sudo.enable = true;
}
