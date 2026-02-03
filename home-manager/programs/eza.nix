{ config, pkgs, lib, ... }:

{
  # Eza: The 'ls' replacement with superpowers
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
