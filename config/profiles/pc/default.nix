{ config, pkgs, inputs, ... }: {
  imports = [
    ../physical-machine

    ../../modules/security/gpg

    ../../modules/system/devices/bluetooth
    ../../modules/system/devices/udisk
    ../../modules/system/nix-direnv

    ../../modules/ui/audio
    ../../modules/ui/direnv
    ../../modules/ui/dunst
    ../../modules/ui/fonts
    ../../modules/ui/opengl
    ../../modules/ui/picom
    ../../modules/ui/kitty
    ../../modules/ui/st
    ../../modules/ui/xserver

    # ../../modules/ui/termonad
    # ../../modules/ui/eww

    # TODO: Write Modules:
    # ../../modules/ui/emacs
    # ../../../modules/nixos/lightlocker.nix
    # ../../modules/ui/zathura # Home Manager
  ];

  # TODO(xz): figure out what's going on here...
  # nixpkgs.overlays = [ (import ../../../overlays/graphqurl.nix) ];

  environment.systemPackages = with pkgs; [
    # cli basics
    btop
    duf
    dust
    eza
    fzf
    mcfly
    ripgrep
    starship
    zoxide

    # terminal emulators
    alacritty
    kitty
    urxvt
    wezterm
    xterm

    # editors
    emacs29
    vscode
    neovim

    # desktop environment
    brightnessctl
    eww
    libnotify
    wmctrl
    xclip
    xlayoutdisplay

    # media
    pavucontrol
    picard
    vlc
    scrot
    zathura

    # secret management
    yubioath-flutter

    # chat
    discord
    signal-desktop
    slack
    telegram-desktop
    zoom-us

    # browsers
    brave
    firefox
    google-chrome
    surf

    # miscellaneous...
    ispell
    udiskie
    sqlite
    zotero
    filezilla
  ];

  primary-user.home-manager.programs.rofi = {
    enable = true;

    # TODO(xz): figure out what's going on here...
    # location = "top";

    plugins = [
      pkgs.rofi-calc
      pkgs.rofi-emoji

      # TODO(xz): figure out what's going on here...
      #  pkgs.rofi-mpd
      #  pkgs.rofi-systemd
      #  pkgs.rofi-power-menu
    ];

    terminal = "${pkgs.wezterm}/bin/wezterm";
  };

  virtualisation = {
    containers = { enable = true; };

    docker = {
      enable = true;
      storageDriver = "devicemapper";
    };
    oci-containers.backend = "docker";
  };

  primary-user.extraGroups = [ "networkmanager" "docker" ];
}
