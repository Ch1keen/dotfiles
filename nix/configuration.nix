# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "ch1keen-nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s5.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enabled = "kime";
    kime.config = {
      indicator.icon_color = "White";
      engine.hangul.layout = "sebeolsik-3-90";
    };
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager = {
    sddm.enable = true;
    defaultSession = "none+awesome";
  };

  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      luarocks
      luadbi-mysql
    ];
  };

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;
  #services.xserver.synaptics.enable = true;

  # Enable GNU Guix Service
  # ref: https://euandre.org/2018/07/17/running-guix-on-nixos.html
  systemd.services.guix-daemon = {
    enable = true;
    description = "Build daemon for GNU Guix";
    serviceConfig = {
      ExecStart = "/var/guix/profiles/per-user/root/current-guix/bin/guix-daemon --build-users-group=guixbuild";
      Environment = "GUIX_LOCPATH=/root/.guix-profile/lib/locale";
      RemainAfterExit = "yes";
      StandardOutput = "syslog";
      StandardError = "syslog";
      TaskMax = "8192";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;

    extraUsers =
      let
        ch1keenUser = {
	  ch1keen = {
	    isNormalUser = true;
	    extraGroups = [ "wheel" "docker" "libvirtd" "audio" ];
	    initialPassword = "aaaa";
	  };
	};
	buildUser = (i:
	  {
	    "guixbuilder${i}" = {
	      group = "groupbuild";
	      extraGroups = ["guixbuild"];
	      home = "/var/empty";
	      shell = pkgs.nologin;
	      description = "Guix build user ${i}";
	      isSystemUser = true;
	    };
	  }
        );
      in
        pkgs.lib.fold (str: acc: acc // buildUser str)
			ch1keenUser
			(map (pkgs.lib.fixedWidthNumber 2) (builtins.genList (n: n+1) 10));
    extraGroups.guixbuild = {
      name = "guixbuild";
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  programs.dconf.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.variables = {
    GTK_IM_MODULE = "kime";
    QT4_IM_MODULE = "kime";
    QT_IM_MODULE  = "kime";
    XMODIFIERS    = "@im=kime";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    firefox
    kime
    gnupg
    alacritty
    nodejs
    patchelf
    file
    tdesktop  # It can then be run as `telegram-desktop`
    discord
    virt-manager
    docker-compose
    minikube
    kubectl
    xfce.thunar
    xfce.xfce4-icon-theme
    tor-browser-bundle-bin
    pavucontrol
    gnome.simple-scan
  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    d2coding
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint pkgs.hplip ];

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
  system.stateVersion = "21.11"; # Did you read the comment?

}

