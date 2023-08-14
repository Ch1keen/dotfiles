{ config, lib, pkgs, ... }:
{
  services.nix-daemon.enable = true;
  nix.package = pkgs.nixVersions.unstable;
  nix.settings.sandbox = false;
  nix.extraOptions = ''
    build-users-group = nixbld
    experimental-features = nix-command flakes
  '';

  users.users.hanjeongjun = {
    name = "hanjeongjun";
    home = "/Users/hanjeongjun";
  };
  programs.zsh.enable = true;
  system.stateVersion = 4;
}
