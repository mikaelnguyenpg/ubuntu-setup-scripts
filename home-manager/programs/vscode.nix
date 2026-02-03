{ config, pkgs, lib, ... }:

let
  # Override VS Code to include --no-sandbox flag
  vscode-no-sandbox = pkgs.vscode.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      wrapProgram $out/bin/code --add-flags "--no-sandbox"
    '';
  });
in {
  programs.vscode = {
    enable = true;
    package = vscode-no-sandbox;
    # package = pkgs.vscode.fhs;

    # Enable mutable settings (optional)
    mutableExtensionsDir = true; # Set to true if you want to allow manual extension installations

    profiles.default.userSettings = {
      # General settings
      "editor.lineNumbers" = "relative";
      "editor.fontSize" = 14;
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "window.zoomLevel" = 1;
      "terminal.integrated.shell" = "${pkgs.zsh}/bin/zsh"; # Use zsh as the integrated terminal shell
      "terminal.integrated.defaultProfile.linux" = "zsh";

      # Theme (matching your tmux tokyo-night theme)
      "workbench.colorTheme" = "Tokyo Night Storm";

      # Vim keybindings (optional, since you use vim-tmux-navigator)
      "vim.easymotion" = true;
      "vim.handleKeys" = {
        "<C-a>" = false;
        "<C-f>" = false;
        "<C-p>" = false;
        "<C-w>" = false;
      };
      "vim.leader" = "<space>";
      # "vim.normalModeKeyBindingsNonRecursive" = [
      #   {
      #     "before" = ["ctrl" "w"];
      #     "commands" = ["workbench.action.files.save"];
      #   }
      # ];
      "vim.useSystemClipboard" = true;

      # Disable telemetry
      "telemetry.telemetryLevel" = "off";

      "turboConsoleLog.includeFilename" = true;
      "turboConsoleLog.includeLineNum" = true;
      "turboConsoleLog.insertEnclosingClass" = true;
      "turboConsoleLog.insertEnclosingFunction" = true;

      # Flutter
      "dart.flutterSdkPath" = "~/flutter";
      ## Android iOS Emulator
      "emulator.emulatorPathLinux" = "~/Android/Sdk/emulator";
      # "emulator.emulatorPathMac" = "~/Library/Android/sdk/emulator";
    };

    # Manage keybindings
    profiles.default.keybindings = [
      {
        "key" = "ctrl+shift+t";
        "command" = "workbench.action.terminal.toggleTerminal";
        "when" = "editorTextFocus";
      }
      {
        "key" = "ctrl+alt+t";
        "command" = "workbench.action.terminal.new";
        "when" = "terminalFocus";
      }
    ];

    # Install extensions
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # attilabuti.vscode-mjml
      # britesnow.vscode-toggle-quotes
      # burkeholland.simple-react-snippets
      # chakrounanas.turbo-console-log
      # dsznajder.es7-react-js-snippets
      # exodiusstudios.comment-anchors
      # george-alisson.html-preview-vscode
      # jasew.vscode-helix-emulation # optional
      # ms-vscode.vscode-typescript-next
      # pkief.material-icon-theme # optional
      # steoates.autoimport
      # wallabyjs.console-ninja # optional

      adpyke.codesnap
      bradlc.vscode-tailwindcss
      dbaeumer.vscode-eslint
      dracula-theme.theme-dracula
      eamodio.gitlens
      ecmel.vscode-html-css

      # Tokyo Night theme (matching your tmux theme)
      enkia.tokyo-night
      esbenp.prettier-vscode
      grapecity.gc-excelviewer
      jnoortheen.nix-ide
      meganrogge.template-string-converter
      mikestead.dotenv
      # ms-python.python # BUG:
      oderwat.indent-rainbow
      vscode-icons-team.vscode-icons

      # Vim extension (optional, for vim keybindings)
      vscodevim.vim
      wix.vscode-import-cost
      yoavbls.pretty-ts-errors
      zainchen.json
    ];
  };
}
