{ config, pkgs, ... }:

let
  basic_packages = import ../../src/packages.nix { inherit pkgs; };
  clang_packages = import ../../src/clang.nix { inherit pkgs; };
in {

  imports = [ ../light.nix ];

  home.packages = [
    # Nerdfont
    pkgs.nerdfonts
    pkgs.nanum

    # Utilities
    pkgs.gparted
    pkgs.github-desktop
    pkgs.simple-scan

    # Browser
    pkgs.tor-browser-bundle-bin

    # Messenger & Work
    pkgs.tdesktop
    #pkgs.slack
    #pkgs.vscode
    # slack & vscode require unfree settings, just install it manually:
    # $ NIXPKGS_ALLOW_UNFREE=1 nix-env -iA nixos.slack

    # Hacking Related
    pkgs.zap
    pkgs.ghidra
    #pkgs.burpsuite
    pkgs.radare2
    pkgs.rizin
    pkgs.gef  # python3.10 ropper is broken on darwin

    # Radio Signal
    #pkgs.gqrx
    #pkgs.sigdigger
  ] ++ basic_packages ++ clang_packages;

  # Korean Language
  home.sessionVariables = {
    GTK_IM_MODULE = "kime";
    QT_IM_MODULE = "kime";
    QT4_IM_MODULE = "kime";
    XMODIFIERS = "@im=kime";
  };

  i18n.inputMethod.enabled = "kime";
  i18n.inputMethod.kime.config = {
    daemon = {
      modules = ["Xim" "Indicator"];
    };
    indicator = {
      icon_color = "White";
    };
    engine = {
      hangul = {
        layout = "sebeolsik-3-90";
      };
    };
    global_hotkeys.S-Space.behavior.Toggle = ["Hangul" "Latin"];
  };

  # bluetooth
  services.blueman-applet.enable = true;

  # qutebrowser
  programs.qutebrowser.enable = true;

  # Alacritty
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    font.size = 8;
  };

  # Picom
  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
  };
}
