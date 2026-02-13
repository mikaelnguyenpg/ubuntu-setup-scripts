{ config, pkgs, lib, ... }:

{
  # =============================================================================
  #                            ACTIVATION SCRIPTS
  # =============================================================================
  home.activation = {
    initializeNvim = lib.hm.dag.entryAfter ["installPackages"] ''
      echo " - Initializing LazyVim Configuration..."
      if [ ! -d "$HOME/.config/nvim" ]; then
        ${pkgs.git}/bin/git clone --depth=1 "${constants.lazyvimRepo}" "$HOME/.config/nvim"
      else
        echo "Nvim config already exist!"
      fi
    '';
  };
}
