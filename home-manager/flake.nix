{
  description = "Home Manager configuration of eagle";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { nixpkgs, home-manager, flatpak, nixGL, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = "eagle";
    in {
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ nixGL.overlay ];
        };

        extraSpecialArgs = { inherit nixGL; };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          flatpak.homeManagerModules.nix-flatpak
          ./home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
