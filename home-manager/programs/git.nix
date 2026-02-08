{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "mikaelnguyenpg";
        email = "mikaelnguyenpg@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "hx"; # Hoặc nvim, code...
    };
  };
}
