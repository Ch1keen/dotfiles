{
  description = "Home Manager configuration of Ch1keen";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, darwin, nixvim, ... }: {
    # home-manager switch --flake '/home/ch1keen/.config/nixpkgs#ch1keen'
    homeConfigurations.ch1keen = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ platform/linux/home.nix ];
    };

    # home-manager switch --flake '/home/ch1keen/.config/nixpkgs#ch1keen-light'
    homeConfigurations.ch1keen-light = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ platform/light.nix ] ;
    };

    # darwin-rebuild switch --flake ~/.config/nix-darwin/
    darwinConfigurations = {
      "hanjeongjun-ui-MacBookPro" = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          platform/darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hanjeongjun = import platform/darwin/home.nix;
          }
        ];
      };
    };
  };
}
