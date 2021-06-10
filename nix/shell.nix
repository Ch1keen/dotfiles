{pkgs ? import <nixpkgs> {}
}:
let
  vscodium-with-extensions = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    vscodeExtensions = [
      pkgs.vscode-extensions.bbenoist.Nix
      pkgs.vscode-extensions.jnoortheen.nix-ide
    ];
  };
in pkgs.mkShell {
  name="nix-edit";
  buildInputs = [
    # VSCodium for editing several .nix file
    vscodium-with-extensions
  ];
  shellHook = ''
    echo "Live how you want!"
  '';
}
