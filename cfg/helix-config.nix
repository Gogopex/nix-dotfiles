{
  enable = true;
  settings = {
    theme = "gruvbox";
    editor = {
      bufferline = "multiple";
      line-number = "absolute";
      auto-completion = true;
      soft-wrap = {
        enable = true;
      };
      auto-save = {
        focus-lost = true;
      };
      completion-trigger-len = 2;
      mouse = false;
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      file-picker.hidden = false;
      statusline = {
        left = [
          "mode"
          "spinner"
        ];
        center = [ "file-name" ];
        right = [
          "diagnostics"
          "selections"
          "position"
          "file-encoding"
          "file-line-ending"
          "file-type"
        ];
        separator = "│";
        mode = {
          normal = "NORMAL";
          insert = "INSERT";
          select = "SELECT";
        };
      };
      inline-diagnostics = {
        cursor-line = "warning";
        other-lines = "error";
      };
      lsp = {
        display-inlay-hints = true;
      };
    };

    keys = {
      select = {
        G = "goto_last_line";
      };
      normal = {
        "C-o" = ":config-open";
        "C-r" = ":config-reload";

        "space" = {
          "u" = {
            "c" = ":set auto-completion true";
            "C" = ":set auto-completion false";
          };
          "y" = {
            "p" = [
              ":sh printf \"%s\" \"{file-path}\" | pbcopy"
              ":echo Copied file path to clipboard"
            ];
            "g" = [
              ":sh url=$(git config --get remote.origin.url 2>/dev/null); slug=$(printf %s \"$url\" | sed -E 's#^git@[^:]*:##; s#^ssh://[^/]+/##; s#^https?://[^/]+/##; s#\\.git$##'); branch=$(git rev-parse --abbrev-ref HEAD); echo \"https://github.com/$slug/blob/$branch/{file-path-relative}#L{cursor-line}\" | pbcopy"
              ":echo Copied GitHub link to clipboard"
            ];
          };
        };

        "{" = [
          "goto_prev_paragraph"
          "collapse_selection"
        ];
        "}" = [
          "goto_next_paragraph"
          "collapse_selection"
        ];

        G = "goto_last_line";
        "%" = "match_brackets";
        V = [
          "select_mode"
          "extend_to_line_bounds"
        ];

        D = [
          "extend_to_line_end"
          "yank_main_selection_to_clipboard"
          "delete_selection"
        ];

        S = "surround_add";

        x = "delete_selection";

        p = [
          "paste_clipboard_after"
          "collapse_selection"
        ];
        P = [
          "paste_clipboard_before"
          "collapse_selection"
        ];

        w = [
          "move_next_word_start"
          "move_char_right"
          "collapse_selection"
        ];
        W = [
          "move_next_long_word_start"
          "move_char_right"
          "collapse_selection"
        ];
        e = [
          "move_next_word_end"
          "collapse_selection"
        ];
        E = [
          "move_next_long_word_end"
          "collapse_selection"
        ];
        b = [
          "move_prev_word_start"
          "collapse_selection"
        ];
        B = [
          "move_prev_long_word_start"
          "collapse_selection"
        ];

        i = [
          "insert_mode"
          "collapse_selection"
        ];
        a = [
          "append_mode"
          "collapse_selection"
        ];

        u = [
          "undo"
          "collapse_selection"
        ];

        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];

        "*" = [
          "move_char_right"
          "move_prev_word_start"
          "move_next_word_end"
          "search_selection"
          "search_next"
        ];

        j = "move_line_down";
        k = "move_line_up";

        d = {
          d = [
            "extend_to_line_bounds"
            "yank_main_selection_to_clipboard"
            "delete_selection"
          ];
          t = [ "extend_till_char" ];
          s = [ "surround_delete" ];
          i = [ "select_textobject_inner" ];
          a = [ "select_textobject_around" ];

          w = [
            "move_next_word_start"
            "yank_main_selection_to_clipboard"
            "delete_selection"
          ];
          W = [
            "move_next_long_word_start"
            "yank_main_selection_to_clipboard"
            "delete_selection"
          ];
        };

        y = {
          y = [
            "extend_to_line_bounds"
            "yank_main_selection_to_clipboard"
            "normal_mode"
            "collapse_selection"
          ];
          j = [
            "select_mode"
            "extend_to_line_bounds"
            "extend_line_below"
            "yank_main_selection_to_clipboard"
            "collapse_selection"
            "normal_mode"
          ];
          k = [
            "select_mode"
            "extend_to_line_bounds"
            "extend_line_above"
            "yank_main_selection_to_clipboard"
            "collapse_selection"
            "normal_mode"
          ];
          G = [
            "select_mode"
            "extend_to_line_bounds"
            "goto_last_line"
            "extend_to_line_bounds"
            "yank_main_selection_to_clipboard"
            "collapse_selection"
            "normal_mode"
          ];
          w = [
            "move_next_word_start"
            "yank_main_selection_to_clipboard"
            "collapse_selection"
            "normal_mode"
          ];
          W = [
            "move_next_long_word_start"
            "yank_main_selection_to_clipboard"
            "collapse_selection"
            "normal_mode"
          ];
          g.g = [
            "select_mode"
            "extend_to_line_bounds"
            "goto_file_start"
            "extend_to_line_bounds"
            "yank_main_selection_to_clipboard"
            "collapse_selection"
            "normal_mode"
          ];
        };
      };

      insert = {
        esc = [
          "collapse_selection"
          "normal_mode"
        ];
      };

      select = {
        "{" = [
          "extend_to_line_bounds"
          "goto_prev_paragraph"
        ];
        "}" = [
          "extend_to_line_bounds"
          "goto_next_paragraph"
        ];
        "0" = "goto_line_start";
        "$" = "goto_line_end";
        "^" = "goto_first_nonwhitespace";
        G = "goto_file_end";
        D = [
          "extend_to_line_bounds"
          "delete_selection"
          "normal_mode"
        ];
        "%" = "match_brackets";
        S = "surround_add";
        u = [
          "switch_to_lowercase"
          "collapse_selection"
          "normal_mode"
        ];
        U = [
          "switch_to_uppercase"
          "collapse_selection"
          "normal_mode"
        ];

        i = "select_textobject_inner";
        a = "select_textobject_around";

        tab = [
          "insert_mode"
          "collapse_selection"
        ];
        "C-a" = [
          "append_mode"
          "collapse_selection"
        ];

        k = [
          "extend_line_up"
          "extend_to_line_bounds"
        ];
        j = [
          "extend_line_down"
          "extend_to_line_bounds"
        ];

        d = [
          "yank_main_selection_to_clipboard"
          "delete_selection"
        ];
        x = [
          "yank_main_selection_to_clipboard"
          "delete_selection"
        ];
        y = [
          "yank_main_selection_to_clipboard"
          "normal_mode"
          "flip_selections"
          "collapse_selection"
        ];
        Y = [
          "extend_to_line_bounds"
          "yank_main_selection_to_clipboard"
          "goto_line_start"
          "collapse_selection"
          "normal_mode"
        ];
        p = "replace_selections_with_clipboard";
        P = "paste_clipboard_before";

        esc = [
          "collapse_selection"
          "keep_primary_selection"
          "normal_mode"
        ];
      };
    };
  };
  languages = {
    language = [
      {
        name = "nix";
        formatter = {
          command = "nixfmt";
        };
        language-servers = [ "nixd" ];
      }
      {
        name = "rust";
        auto-format = true;
        formatter = {
          command = "rustfmt";
        };
        language-servers = [ "rust-analyzer" ];
      }
      {
        name = "go";
        auto-format = true;
        formatter = {
          command = "gofumpt";
        };
        language-servers = [ "gopls" ];
      }
      {
        name = "python";
        auto-format = true;
        formatter = {
          command = "ruff";
          args = [
            "format"
            "-"
          ];
        };
        language-servers = [ "pyright" ];
      }
      {
        name = "javascript";
        auto-format = true;
        formatter = {
          command = "prettier";
          args = [
            "--parser"
            "babel"
          ];
        };
        language-servers = [ "typescript-language-server" ];
      }
      {
        name = "typescript";
        auto-format = true;
        formatter = {
          command = "prettier";
          args = [
            "--parser"
            "typescript"
          ];
        };
        language-servers = [ "typescript-language-server" ];
      }
      {
        name = "jsx";
        auto-format = true;
        formatter = {
          command = "prettier";
          args = [
            "--parser"
            "babel"
          ];
        };
        language-servers = [ "typescript-language-server" ];
      }
      {
        name = "tsx";
        auto-format = true;
        formatter = {
          command = "prettier";
          args = [
            "--parser"
            "typescript"
          ];
        };
        language-servers = [ "typescript-language-server" ];
      }
      {
        name = "json";
        formatter = {
          command = "prettier";
          args = [
            "--parser"
            "json"
          ];
        };
        language-servers = [ "vscode-json-language-server" ];
      }
      {
        name = "html";
        formatter = {
          command = "prettier";
          args = [
            "--parser"
            "html"
          ];
        };
        language-servers = [ "vscode-html-language-server" ];
      }
      {
        name = "css";
        formatter = {
          command = "prettier";
          args = [
            "--parser"
            "css"
          ];
        };
        language-servers = [ "vscode-css-language-server" ];
      }
      {
        name = "markdown";
        formatter = {
          command = "prettier";
          args = [
            "--parser"
            "markdown"
          ];
        };
      }
      {
        name = "yaml";
        formatter = {
          command = "prettier";
          args = [
            "--parser"
            "yaml"
          ];
        };
        language-servers = [ "yaml-language-server" ];
      }
      {
        name = "zig";
        auto-format = true;
        formatter = {
          command = "zig";
          args = [
            "fmt"
            "--stdin"
          ];
        };
        language-servers = [ "zls" ];
      }
      {
        name = "odin";
        language-servers = [ "ols" ];
      }
      {
        name = "java";
        auto-format = true;
        formatter = {
          command = "google-java-format";
          args = [ "-" ];
        };
        language-servers = [ "jdtls" ];
      }
      {
        name = "haskell";
        auto-format = true;
        formatter = {
          command = "fourmolu";
          args = [
            "--stdin-input-file"
            "."
          ];
        };
        language-servers = [ "haskell-language-server" ];
      }
    ];

    language-server = {
      nixd = {
        command = "nixd";
      };
      rust-analyzer = {
        command = "rust-analyzer";
        config = {
          check = {
            command = "clippy";
          };
        };
      };
      gopls = {
        command = "gopls";
        config = {
          analyses = {
            unusedparams = true;
            staticcheck = true;
          };
        };
      };
      pyright = {
        command = "pyright-langserver";
        args = [ "--stdio" ];
        config = {
          python.analysis = {
            typeCheckingMode = "basic";
            autoSearchPaths = true;
            useLibraryCodeForTypes = true;
          };
        };
      };
      typescript-language-server = {
        command = "typescript-language-server";
        args = [ "--stdio" ];
        config = {
          typescript = {
            inlayHints = {
              parameterNames.enabled = "all";
              parameterTypes.enabled = true;
              variableTypes.enabled = true;
              propertyDeclarationTypes.enabled = true;
              functionLikeReturnTypes.enabled = true;
              enumMemberValues.enabled = true;
            };
          };
        };
      };
      vscode-json-language-server = {
        command = "vscode-json-language-server";
        args = [ "--stdio" ];
      };
      vscode-html-language-server = {
        command = "vscode-html-language-server";
        args = [ "--stdio" ];
      };
      vscode-css-language-server = {
        command = "vscode-css-language-server";
        args = [ "--stdio" ];
      };
      yaml-language-server = {
        command = "yaml-language-server";
        args = [ "--stdio" ];
      };
      zls = {
        command = "zls";
      };
      ols = {
        command = "ols";
      };
      jdtls = {
        command = "jdtls";
      };
      haskell-language-server = {
        command = "haskell-language-server-wrapper";
        args = [ "--lsp" ];
      };
    };
  };
}
