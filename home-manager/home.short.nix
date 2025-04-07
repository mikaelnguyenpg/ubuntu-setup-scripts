{ config, pkgs, lib, ... }:
let
  constants = import ./constants.nix;
  packages = import ./packages.nix { inherit pkgs; };
  programConfigs = import ./programs.nix { inherit pkgs lib; };
in {
  home.username = constants.username;
  home.homeDirectory = constants.homeDir;
  home.stateVersion = constants.stateVersion;
  home.packages = packages.allPackages;
  home.file = {};
  home.activation = { /* ... */ };
  home.sessionVariables = { EDITOR = "hx"; };
  services = { flameshot.enable = true; };
  programs = programConfigs // {
    home-manager.enable = true;
    # Simple enables
  };
}
