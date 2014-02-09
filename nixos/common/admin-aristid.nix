{ config, ... }:

let sshKeyFiles = [ ../../ssh/mba_rsa.pub
                    ../../ssh/medusa_rsa.pub
                    ../../ssh/nixstick.pub
                    ../../ssh/euphemus_rsa.pub
                  ]; in
{
  users.extraUsers = { root = { openssh.authorizedKeys.keyFiles = sshKeyFiles ++ [ ../../ssh/euphemus_root.pub ]; };
                       aristid = { createUser = true;
                                   uid = 1000;
                                   createHome = true;
                                   description = "Aristid Breitkreuz";
                                   group = "users";
                                   extraGroups = [ "wheel" ];
                                   home = "/home/aristid";
                                   useDefaultShell = true;
                                   openssh.authorizedKeys.keyFiles = sshKeyFiles;
                                 };
                     };

  security.sudo.enable = true;
}
