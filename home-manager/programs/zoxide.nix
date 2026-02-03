{ config, pkgs, lib, ... }:

{
  # Zoxide: The smarter 'cd'
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    # Replace cd with z (optional, but recommended for 'Pro' workflow)
    # options = [ "--cmd cd" ];
  };
}
