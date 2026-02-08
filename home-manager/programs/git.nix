{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    enableZshIntegration = true;
    userName  = "mikaelnguyenpg";
    userEmail = "mikaelnguyenpg@gmail.com";
    # settings = {
    #   user = {
    #     name = "mikaelnguyenpg";
    #     email = "mikaelnguyenpg@gmail.com";
    #   };
    # };

    # extraConfig = {
    #   init.defaultBranch = "main";
    #   pull.rebase = false;
    #   core.editor = "hx"; # Hoặc nvim, code...
    # };

    # Replace cd with z (optional, but recommended for 'Pro' workflow)
    # options = [ "--cmd cd" ];
  };
}
