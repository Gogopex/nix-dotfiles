{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) merge mkIf;
  inherit (builtins) toJSON;

  zedSettings = {
    auto_install_extensions = {
      json = true;
      markdown = true;
      nix = true;
      python = true;
      rust = true;
      swift = true;
      toml = true;
    };

    auto_update = false;

    buffer_font_family = config.theme.font.mono.name;
    buffer_font_size = config.theme.font.size.normal;
    ui_font_family = config.theme.font.sans.name;
    ui_font_size = config.theme.font.size.normal;

    confirm_quit = true;
    features = {
      copilot = false;
    };
    restore_on_startup = "last_workspace";
    telemetry = {
      diagnostics = false;
      metrics = false;
    };
    theme = "Gruvbox Dark";
    vim_mode = true;

    tab_size = 2;
    hard_tabs = false;
    soft_wrap = "preferred_line_length";
    preferred_line_length = 80;
    show_whitespaces = "selection";
    show_indent_guides = true;
    indent_guides = {
      enabled = true;
      coloring = "indent_aware";
    };

    terminal = {
      font_family = config.theme.font.mono.name;
      font_size = config.theme.font.size.normal;
    };

    git = {
      inline_blame = {
        enabled = true;
      };
    };

    languages = {
      Nix = {
        tab_size = 2;
        formatter = {
          external = {
            command = "nixfmt";
            arguments = [ ];
          };
        };
      };
      Rust = {
        tab_size = 4;
        formatter = {
          external = {
            command = "rustfmt";
            arguments = [ "--edition=2021" ];
          };
        };
      };
      Python = {
        tab_size = 4;
        formatter = {
          external = {
            command = "ruff";
            arguments = [
              "format"
              "-"
            ];
          };
        };
      };
      JavaScript = {
        tab_size = 2;
        formatter = {
          external = {
            command = "prettier";
            arguments = [
              "--parser"
              "babel"
            ];
          };
        };
      };
      TypeScript = {
        tab_size = 2;
        formatter = {
          external = {
            command = "prettier";
            arguments = [
              "--parser"
              "typescript"
            ];
          };
        };
      };
    };
  };

  zedKeymap = [
    {
      context = "Editor && vim_mode == normal";
      bindings = {
        "g h" = "editor::MoveToBeginningOfLine";
        "g l" = "editor::MoveToEndOfLine";
        "g g" = "editor::MoveToBeginning";
        "G" = "editor::MoveToEnd";

        "space y" = "editor::Copy";
        "space d" = "editor::Delete";
      };
    }
    {
      context = "Editor && vim_mode == visual";
      bindings = {
        "space y" = "editor::Copy";
        "space d" = "editor::Delete";
      };
    }
  ];

in
mkIf config.editors.zed.enable (merge {
  home-manager.sharedModules = [
    {
      home.file.".config/zed/settings.json" = mkIf pkgs.stdenv.isDarwin {
        text = toJSON zedSettings;
      };

      home.file.".config/zed/keymap.json" = mkIf pkgs.stdenv.isDarwin {
        text = toJSON zedKeymap;
      };
    }
  ];
})
