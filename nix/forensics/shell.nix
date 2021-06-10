{ pkgs ? import <nixpkgs> {}
}:
pkgs.mkShell {
  name="pwnable";
  buildInputs = [
    # Language for writing scripts
    pkgs.python39
    pkgs.ruby_2_7

    # NeoVim & tmux rules
    pkgs.neovim
    pkgs.tmux
    
    # EXIF Informations
    pkgs.exif
    pkgs.exiftags
    pkgs.exifprobe
  ];
  shellHook = ''
    tmux
  '';
}
