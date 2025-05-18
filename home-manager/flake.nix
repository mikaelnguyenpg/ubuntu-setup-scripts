{
  description = "Home Manager configuration of eagle";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { nixpkgs, home-manager, flatpak, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."eagle" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

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
