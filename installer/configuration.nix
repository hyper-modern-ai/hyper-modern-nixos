{ config, pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    extraConfig = "PermitUserEnvironment yes";
  };

  programs.ssh.startAgent = true;

  services.sshd.enable = true;

  security.pam = {
    enableSSHAgentAuth = true;
    services.sudo.sshAgentAuth = true;
  };

  users = {
    mutableUsers = false;
    users.b7r6 = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "keys" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjp4zAsIR3EsYW1yIRQpaaXSXgaWwMji22rnstPd4cH b7r6@pm.me"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAeh8RZ1WSdbDOEDN1UtdBI6sdxxnRkqPbh8c0aQt38g theshe1k@ltcm.exchange"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMh3ATmMA+XXUKySUXM0HKtVsbrb9kZMOX6k7hkRH5v reinit-ctx-offset@xz.team"
      ];
      passwordFile = "/etc/primary-user-password";
    };
    users.root.hashedPassword = "*";
  };

  nix.settings.trusted-users = [ "root" "b7r6" ];
  nix.package = pkgs.nixUnstable;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  users.users.root.openssh.authorizedKeys.keyFiles =
    [ /etc/ssh/authorized_keys.d/root ];

  networking = {
    hostName = "nixos";
    wireless.enable = true;
    useDHCP = lib.mkDefault true;

    # TODO: This should be generated in the install.sh script
    hostId = "997f3c8d";
  };

  environment.systemPackages = [ pkgs.vim pkgs.git ];

  system.stateVersion = "23.11";
}
