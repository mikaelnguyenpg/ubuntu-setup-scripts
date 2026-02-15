{ config, pkgs, lib, ... }:

let
  lazyvimRepo = "https://github.com/mikaelnguyenpg/nvim-starter.git";
in {
  # =============================================================================
  #                            ACTIVATION SCRIPTS
  # =============================================================================
  home.activation = {
    initializeNvim = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo " - Initializing LazyVim Configuration..."
      if [ ! -d "$HOME/.config/nvim" ]; then
        ${pkgs.git}/bin/git clone --depth=1 "${lazyvimRepo}" "$HOME/.config/nvim"
      else
        echo "Nvim config already exist!"
      fi
    '';
  };
}
