{ config, pkgs, lib, nixGL, ... }:

let
    # ────────────────────────────────────────────────────────────────
    # 7. NixGL wrapped apps (cần chạy GUI với nixGL)
    # ────────────────────────────────────────────────────────────────
    nixGLApps = [
      # (config.lib.nixGL.wrap neovide)
      # (config.lib.nixGL.wrap notepadqq)
      # (config.lib.nixGL.wrap jetbrains.webstorm)
    ];

in {
  # =============================================================================
  #                            GRAPHICS & DRIVERS
  # =============================================================================
  targets.genericLinux = {
    enable = true;

    nixGL = {
      packages = nixGL.packages.${pkgs.system}; # Import nixGL package set
      defaultWrapper = "mesa";   # Use Mesa for Intel/AMD or Nouveau
      installScripts = ["mesa"]; # Install nixGLMesa script
    };
  };

  home.packages = nixGLApps;
}
