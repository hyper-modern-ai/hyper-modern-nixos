{ pkgs, ... }: {
  programs.gnupg.agent = {
    enable = true;

    # TODO(xz): figure out what's going on here...
    # enableSSHSupport = true;
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];

  services.pcscd.enable = true;

  environment.systemPackages = [
    pkgs.age-plugin-yubikey
    pkgs.passage
    pkgs.rage
    pkgs.yubikey-manager
    pkgs.yubikey-manager-qt
  ];

  environment.variables = { PASSAGE_AGE = "rage"; };
}
