{ config, pkgs, ... }:

let
  basic_packages = import ../../src/packages.nix { inherit pkgs; };
in {

  imports = [ ../light.nix ];

  home.packages = [
    # Utilities
    pkgs.gparted
    pkgs.github-desktop

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
  ] ++ basic_packages;

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

  # qutebrowser
  programs.qutebrowser.enable = true;

  # Alacritty
  programs.alacritty.enable = true;
}
