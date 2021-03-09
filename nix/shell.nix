{pkgs ? import <nixpkgs> {}
}:
pkgs.mkShell {
  name="nix-edit";
  buildInputs = [
    # VSCodium for editing several .nix file
    pkgs.vscodium
    pkgs.vscode-extensions.bbenoist.Nix
    pkgs.vscode-extensions.jnoortheen.nix-ide
    pkgs.vscode-extensions.ms-python.python
  ];
  shellHook = ''
    echo "Live how you want!"
  '';
}
