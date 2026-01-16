{ lib, ... }:
let
  inherit (lib) enabled merge;
in
merge {
  home-manager.sharedModules = [
    {
      programs.helix = enabled {
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

              G = [
                "extend_to_line_bounds"
                "goto_last_line"
                "extend_to_line_bounds"
              ];
              g = {
                g = [
                  "collapse_selection"
                  "goto_file_start"
                ];
              };
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
              G = [
                "extend_to_file_end"
                "extend_to_line_bounds"
              ];
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

              k = [ "extend_line_up" "extend_to_line_bounds" ];
              j = [ "extend_line_down" "extend_to_line_bounds" ];

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
              language-servers = [
                "rust-analyzer"
                "lsp-ai"
              ];
              debugger = {
                name = "lldb-dap";
                transport = "stdio";
                command = "lldb-dap";
                templates = [
                  {
                    name = "binary";
                    request = "launch";
                    completion = [
                      {
                        name = "binary";
                        completion = "filename";
                      }
                    ];
                    args = {
                      program = "{0}";
                    };
                  }
                ];
              };
            }
            {
              name = "go";
              auto-format = true;
              formatter = {
                command = "gofumpt";
              };
              language-servers = [
                "gopls"
                "lsp-ai"
              ];
              debugger = {
                name = "delve";
                transport = "tcp";
                command = "dlv";
                args = [ "dap" ];
                port-arg = "-l 127.0.0.1:{port}";
                templates = [
                  {
                    name = "source";
                    request = "launch";
                    completion = [
                      {
                        name = "entrypoint";
                        completion = "filename";
                        default = ".";
                      }
                    ];
                    args = {
                      mode = "debug";
                      program = "{0}";
                    };
                  }
                ];
              };
            }
            {
              name = "swift";
              auto-format = true;
              roots = [
                "Package.swift"
                ".git"
              ];
              formatter = {
                command = "swift-format";
                args = [
                  "format"
                  "--stdin"
                ];
              };
              language-servers = [
                "sourcekit-lsp"
                "lsp-ai"
              ];
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
              language-servers = [
                "ty"
                "lsp-ai"
              ];
              debugger = {
                name = "debugpy";
                transport = "stdio";
                command = "python";
                args = [
                  "-m"
                  "debugpy.adapter"
                ];
                templates = [
                  {
                    name = "source";
                    request = "launch";
                    completion = [
                      {
                        name = "entrypoint";
                        completion = "filename";
                        default = ".";
                      }
                    ];
                    args = {
                      mode = "debug";
                      program = "{0}";
                    };
                  }
                ];
              };
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
              language-servers = [
                "typescript-language-server"
                "lsp-ai"
              ];
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
              language-servers = [
                "typescript-language-server"
                "lsp-ai"
              ];
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
              language-servers = [
                "typescript-language-server"
                "lsp-ai"
              ];
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
              language-servers = [
                "typescript-language-server"
                "lsp-ai"
              ];
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
              language-servers = [
                "haskell-language-server"
                "lsp-ai"
              ];
              debugger = {
                name = "haskell-debug-adapter";
                transport = "stdio";
                command = "haskell-debug-adapter";
                args = [ "--hackage-version=0.0.42.0" ];
                templates = [
                  {
                    name = "launch";
                    request = "launch";
                    completion = [
                      {
                        name = "program";
                        completion = "filename";
                      }
                    ];
                    args = {
                      program = "{0}";
                      stopOnEntry = true;
                    };
                  }
                ];
              };
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
            sourcekit-lsp = {
              command = "sourcekit-lsp";
            };
            ty = {
              command = "ty";
              args = [ "server" ];
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
            lsp-ai = {
              command = "bash";
              args = [
                "-lc"
                "if [ -f /run/agenix/openrouter-api-key ]; then export OPENROUTER_API_KEY=$(cat /run/agenix/openrouter-api-key); fi; exec lsp-ai"
              ];
              config = {
                memory = {
                  file_store = { };
                };
                models = {
                  kimi = {
                    type = "open_ai";
                    chat_endpoint = "https://openrouter.ai/api/v1/chat/completions";
                    model = "moonshotai/kimi-k2";
                    auth_token_env_var_name = "OPENROUTER_API_KEY";
                  };
                };
                completion = {
                  model = "kimi";
                  parameters = {
                    max_context = 16384;
                    max_tokens = 512;
                    temperature = 0.3;
                    min_p = 0.01;
                    messages = [
                      {
                        role = "system";
                        content = "You are an inline coding completion engine for Helix. Output only code to insert at the cursor — no prose, no code fences, and no placeholders. Match the current file’s language, indentation, and style. Prefer minimal, local, immediately runnable edits that fit the surrounding scope. Reuse existing imports, helpers, types, and patterns; do not add new dependencies. Avoid modifying unrelated code or changing public APIs unless the context clearly intends it. Handle errors idiomatically and concisely. Return only the tokens that belong at the cursor.";
                      }
                    ];
                  };
                };
                chat = [
                  {
                    trigger = "!K";
                    action_display_name = "Kimi Assistant";
                    model = "kimi";
                    parameters = {
                      max_context = 32768;
                      max_tokens = 2048;
                      temperature = 0.4;
                      min_p = 0.01;
                      messages = [
                        {
                          role = "system";
                          content = "You are a pragmatic AI coding assistant working inside Helix. Provide concise, concrete solutions with runnable code that follows project conventions. Prefer small, safe diffs with clear rationale and brief trade-offs. When multiple approaches exist, compare quickly and choose one. Include any required commands or configuration to run or test changes. Do not reveal internal chain-of-thought; present conclusions with short justifications.";
                        }
                      ];
                    };
                  }
                ];
                actions = [
                  {
                    action_type = "code_action";
                    action_display_name = "Explain Code";
                    model = "kimi";
                    parameters = {
                      max_context = 16384;
                      max_tokens = 1024;
                      temperature = 0.4;
                      messages = [
                        {
                          role = "system";
                          content = "Explain the selected code to an experienced developer. Use concise bullet points and organize as: Overview (what it does), How it works (flow and key steps), Key types/APIs used, Error handling and edge cases, Performance considerations, Potential pitfalls, Improvement ideas (optional). Focus on the selection and its context; avoid restating obvious syntax.";
                        }
                      ];
                    };
                  }
                  {
                    action_type = "code_action";
                    action_display_name = "Find & Fix Issues";
                    model = "kimi";
                    parameters = {
                      max_context = 16384;
                      max_tokens = 1024;
                      temperature = 0.3;
                      messages = [
                        {
                          role = "system";
                          content = "Analyze the selected code for correctness, edge cases, performance, and readability. Respond with: 1) Issues — a brief bullet list with severity and rationale; 2) Fix — a minimal, safe change that preserves the public API and behavior unless clearly wrong; 3) Patched code — a corrected snippet or diff-ready block without code fences; 4) Notes — one or two sentences explaining why the fix is correct and any trade-offs. Match the project’s style and ensure the result compiles/tests cleanly.";
                        }
                      ];
                    };
                  }
                ];
              };
            };
          };
        };
      };
    }
  ];
}
