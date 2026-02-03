{ config, pkgs, lib, ... }:

{
  username = "eagle";
  homeDir = "/home/eagle";
  stateVersion = "25.11";
  starshipTomlUrl = "https://starship.rs/presets/toml/nerd-font-symbols.toml";
  lazyvimRepo = "https://github.com/mikaelnguyenpg/nvim-starter.git";
}

