{ pkgs ? import <nixpkgs> {}
}:
pkgs.mkShell {
  name="crystal";
  buildInputs = [
    # Language for writing scripts
    pkgs.crystal

    # NeoVim rules
    pkgs.neovim
  ];
  shellHook = ''
    echo "Very simple Crystal environment"
  '';
}
