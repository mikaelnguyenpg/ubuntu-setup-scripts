{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Node.js LSPs & Formatters
    typescript-language-server
    vscode-langservers-extracted # Cho HTML/CSS/JSON
    emmet-ls
    nodePackages.prettier
    tailwindcss-language-server

    # Rust

    # Python
    pyright
    ruff

    # Dart (Thường cài qua Flutter SDK ngoài Nix hoặc qua pkgs.dart)
    # dart
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;

    # settings = {
    #   editor = {
    #     # auto-pairs = true;           # already default in recent Helix
    #     auto-format = true;            # format on :w (if formatter exists)
    #     auto-info = true;
    #     completion-replace = true;
    #     cursorline = true;
    #     # mouse = false;
    #     # rulers = [ 100 ];
    #   };

    #   keys.normal.space = {
    #     # optional convenience keymaps
    #     a = ":code-action";
    #     r = ":rename-symbol";
    #   };
    # };

    settings = {
      theme = "tokyo-night-storm";
      # --- Editor Settings ---
      editor = {
        bufferline = "multiple";
        cursorline = true;
        end-of-line-diagnostics = "hint";
        line-number = "relative";
        rulers = [ 100 ];
        true-color = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
        };

        indent-guides = {
          character = "╎";
          render = true;
        };

        inline-diagnostics = {
          cursor-line = "error";
          other-lines = "disable";
        };

        lsp = {
          auto-signature-help = false;
          display-messages = true;
          display-inlay-hints = true;
        };

        statusline = {
          left = [ "mode" "spinner" "version-control" "file-name" ];
        };
      };

      # --- Keybindings ---
      keys = {
        insert = {
          esc = [ "collapse_selection" "keep_primary_selection" "normal_mode" ];
        };

        normal = {
          esc = [ "collapse_selection" "keep_primary_selection" "normal_mode" ];
          "{" = [ "goto_prev_paragraph" ];
          "}" = [ "goto_next_paragraph" ];
          "^" = [ "goto_first_nonwhitespace" ];
          "G" = [ "goto_last_line" ];
          
          # Tích hợp Yazi (File Manager) và Lazygit
          "C-e" = [ ":new" ":insert-output yazi" ":buffer-close!" ":redraw" ":reload-all" ];
          "C-g" = [ ":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ":reload-all" ];
          
          # Git Blame cho dòng hiện tại (Space + B)
          # "space.B" = ":echo %sh{git show --no-patch --format='%h (%an: %ar): %s' $(git blame -p %{buffer_name} -L%{cursor_line},+1 | head -1 | cut -d' ' -f1)}";
        };

        select = {
          "{" = [ "goto_prev_paragraph" ];
          "}" = [ "goto_next_paragraph" ];
        };
      };
    };

    languages = lib.mkMerge [
      # ────────────────────────────────────────────────────────────────
      # HTML + CSS + Emmet
      # ────────────────────────────────────────────────────────────────
      {
        language-server.emmet-ls = {
          command = "emmet-ls";
          args = [ "--stdio" ];
        };
        language-server.vscode-html-language-server = {
          command = "vscode-html-language-server";
          args = [ "--stdio" ];
        };
        language-server.vscode-css-language-server = {
          command = "vscode-css-language-server";
          args = [ "--stdio" ];
        };

        language = [
          { name = "html";
            roots = [ ".git" ];
            formatter = { command = "prettier"; args = [ "--parser" "html" ]; };
            language-servers = [ "vscode-html-language-server" "emmet-ls" ];
            auto-format = true;
          }
          { name = "css";
            formatter = { command = "prettier"; args = [ "--parser" "css" ]; };
            language-servers = [ "vscode-css-language-server" "tailwindcss-ls" "emmet-ls" ];
            auto-format = true;
          }
          { name = "scss";
            formatter = { command = "prettier"; args = [ "--parser" "scss" ]; };
            language-servers = [ "vscode-css-language-server" "emmet-ls" ];
            auto-format = true;
          }
        ];
      }

      # ────────────────────────────────────────────────────────────────
      # JavaScript / TypeScript / JSX / TSX
      # ────────────────────────────────────────────────────────────────
      {
        language-server.typescript-language-server = {
          command = "typescript-language-server";
          args = [ "--stdio" ];
          config = {
            typescript.inlayHints = {
              includeInlayEnumMemberValueHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayVariableTypeHints = true;
            };
            javascript.inlayHints = {
              includeInlayEnumMemberValueHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayVariableTypeHints = true;
            };
          };
        };
        language-server.tailwindcss-ls = {
          command = "tailwindcss-language-server";
          args = [ "--stdio" ];
        };

        language = [
          { name = "javascript";
            formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
            language-servers = [ "typescript-language-server" "emmet-ls" ];
            auto-format = true;
          }
          { name = "typescript";
            formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
            language-servers = [ "typescript-language-server" "emmet-ls" ];
            auto-format = true;
            scope = "source.ts";
            injection-regex = "(ts|typescript)";
            file-types = [ "ts" ]; # "tsx"
            roots = [ "package.json" "tsconfig.json" ];
            # debugger = { /* ... giữ nguyên phần debugger */ };
          }
          { name = "jsx";
            formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
            language-servers = [ "typescript-language-server" "emmet-ls" ];
            auto-format = true;
          }
          { name = "tsx";
            formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
            language-servers = [ "typescript-language-server" "emmet-ls" ];
            auto-format = true;
          }
        ];
      }

      # ────────────────────────────────────────────────────────────────
      # Rust
      # ────────────────────────────────────────────────────────────────
      {
        language-server.rust-analyzer = {
          # command = "rust-analyzer";
          command =  "rustup";
          args = [ "run" "stable" "rust-analyzer" ];
          config = {
            # Bật diagnostics realtime (gạch đỏ khi đang gõ)
            diagnostics = {
              enable = true;
              disabled = [ "unresolved-proc-macro" ]; # tắt cảnh báo proc macro nếu không cần
            };

            # Inlay hints (hiển thị type, parameter name ngay trong code)
            inlayHints = {
              enable = true;
              lifetimeElisionHints.enable = "skip_trivial";
              closureReturnTypeHints.enable = "with_block";
              reborrowHints.enable = "never";
              typeHints = {
                hideNamedConstructor = false;
              };
              parameterHints = {
                enable = true;
              };
              closingBraceHints = {
                enable = true;
                minLines = 1;
              };
            };

            # Cargo check dùng clippy thay vì check thông thường
            check = {
              command = "clippy";
              # allTargets = false; # nếu không muốn check tests/benches
            };

            # Cargo config (nếu bạn dùng sysroot đặc biệt)
            # cargo = {
            #   # sysroot = "path/to/custom/sysroot"; # hiếm khi cần
            # };
          };
        };

        language = [
          {
            name = "rust";
            scope = "source.rust";
            injection-regex = "rust";
            file-types = [ "rs" ];
            roots = [ "Cargo.toml" "Cargo.lock" ];

            # Auto-format khi save bằng rustfmt
            auto-format = true;
            formatter = {
              command = "rustup";
              args = [ "run" "stable" "rust-fmt" "--edition" "2021" ];
              # command = "rustfmt";
              # args = [ "--edition" "2021" ];
            };

            language-servers = [ "rust-analyzer" ];
          }
        ];
      }

      # ────────────────────────────────────────────────────────────────
      # Python
      # ────────────────────────────────────────────────────────────────
      {
        language-server.pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
          config.python.pythonPath = ".venv/bin/python";
        };
        language-server.ruff-lsp = {
          command = "ruff-lsp";
          args = [ ];
        };

        language = [
          { name = "python";
            scope = "source.python";
            injection-regex = "python";
            file-types = [ "py" "pyi" "py3" "pyw" "ptl" ];
            roots = [ "pyproject.toml" "setup.py" "requirements.txt" ".git" ];
            formatter = { command = "ruff"; args = [ "format" "--quiet" "-" ]; };
            language-servers = [ "pyright" "ruff-lsp" ];
            auto-format = true;
            # debugger = { /* ... giữ nguyên debugpy */ };
          }
        ];
      }

      # ────────────────────────────────────────────────────────────────
      # Dart / Flutter
      # ────────────────────────────────────────────────────────────────
      {
        language-server.dart-language-server = {
          command = "dart";
          args = [ "language-server" "--protocol=lsp" ];
        };
        language-server.dart-debug-adapter = {
          command = "dart";
          args = [ "debug_adapter" ];
        };

        language = [
          { name = "dart";
            scope = "source.dart";
            injection-regex = "dart";
            file-types = [ "dart" "flutter" ];
            roots = [ "pubspec.yaml" ".git" ];
            formatter = { command = "dart"; args = [ "format" ]; };
            language-servers = [ "dart-language-server" ];
            auto-format = true;
            # debugger = { /* ... giữ nguyên phần debugger */ };
          }
        ];
      }

      # ────────────────────────────────────────────────────────────────
      # Các ngôn ngữ khác (JSON, Markdown, v.v.)
      # ────────────────────────────────────────────────────────────────
      {
        language = [
          { name = "json";
            formatter = { command = "prettier"; args = [ "--parser" "json" ]; };
            auto-format = true;
          }
          { name = "markdown";
            injection-regex = "md|markdown";
            file-types = [ "md" "markdown" "txt" ];
            roots = [ ".marksman.toml" ".git" ];

            # Kết nối với server Marksman
            language-servers = [ "marksman" ];

            formatter = { command = "prettier"; args = [ "--parser" "markdown" ]; };
            auto-format = true;
          }
        ];
      }
    ];
  };
}
