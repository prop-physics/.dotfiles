# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.defaultUserShell = pkgs.zsh;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mcrn = {
    isNormalUser = true;
    description = "mcrn";
    extraGroups = [ "networkmanager" "wheel" "docker" "plugdev" ];
    packages = with pkgs; [
      libsForQt5.kio-gdrive
      brave
      firefox
      kate
      vscode-fhs
      slack
      thunderbird
      spotify
      libreoffice
      protonmail-bridge
      btop
      htop
      discord
      telegram-desktop
    ];
  };

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "mcrn" = import ./home.nix;
    };
};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    zsh
    zsh-powerlevel10k
    neovim
    tmux
    git
    docker
    solaar
    waybar
    mako
    libnotify
    swww
    kitty
    wezterm
    rofi-wayland
    networkmanagerapplet
    grim
    slurp
    wl-clipboard
  ];

  fonts.packages = with pkgs; [
    meslo-lgs-nf
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  ### Custom

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs.zsh = {
    enable = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];

  # Power/thermal management
  services.thermald.enable = true;
  #services.tlp = {
  #  enable = true;
  #  settings = {
  #    CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

  #    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

  #    CPU_MIN_PERF_ON_AC = 0;
  #    CPU_MAX_PERF_ON_AC = 100;
  #    CPU_MIN_PERF_ON_BAT = 0;
  #    CPU_MAX_PERF_ON_BAT = 20;

  #    START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #    STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

  #  };
  #};
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
	turbo = "never";
      };
      charger = {
        governor = "performance";
	turbo = "auto";
      };
    };
  };
  
  # Enable yubikey agent
  services.yubikey-agent.enable = true;
  # Ledger udev rules
  services.udev.extraRules = ''
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="2b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="3b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="4b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1807", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1808", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0004", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="1011", MODE="0660", GROUP="plugdev"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="1015", MODE="0660", GROUP="plugdev"
  '';
  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  # Required for solaar
  hardware.logitech.wireless.enable = true;

}
