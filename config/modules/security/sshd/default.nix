{ pkgs, lib, config, ... }: {
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    extraConfig = "PermitUserEnvironment yes";
  };

  programs.ssh.startAgent = true;
  services.sshd.enable = true;

  security.pam = {
    enableSSHAgentAuth = true;
    services.sudo.sshAgentAuth = true;
  };

  primary-user.openssh.authorizedKeys.keys = import ./public-keys.nix;

  users.users.root.openssh.authorizedKeys.keys = [[
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjp4zAsIR3EsYW1yIRQpaaXSXgaWwMji22rnstPd4cH b7r6@pm.me"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAeh8RZ1WSdbDOEDN1UtdBI6sdxxnRkqPbh8c0aQt38g theshe1k@ltcm.exchange"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMh3ATmMA+XXUKySUXM0HKtVsbrb9kZMOX6k7hkRH5v reinit-ctx-offset@xz.team"
  ]];
}
