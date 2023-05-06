{ config, pkgs, lib, ... }:

let
  # for python
  python-with-my-packages = pkgs.python311.withPackages (import ../../src/python-packages.nix);

  # for ruby
  ruby-with-my-packages = pkgs.ruby_3_2.withPackages (import ../../src/ruby-packages.nix);

  basic-packages = import ../../src/packages.nix { inherit pkgs; };
in
 {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = lib.mkForce "hanjeongjun";
  home.homeDirectory = lib.mkForce "/Users/hanjeongjun";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  home.packages = basic-packages;

  imports = [ ../light.nix ];
}
