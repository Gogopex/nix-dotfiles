{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.obsidian;
  
  fetchObsidianPlugin = { url, sha256 }:
    pkgs.fetchzip {
      inherit url sha256;
      stripRoot = false;
    };
    
  installPlugin = pluginName: pluginConfig: 
    let
      pluginSource = fetchObsidianPlugin pluginConfig;
      pluginDir = "${cfg.vaultPath}/.obsidian/plugins/${pluginName}";
    in {
      "${pluginDir}" = {
        source = pluginSource;
        recursive = true;
      };
    };

  appConfig = {
    promptDelete = cfg.settings.promptDelete or false;
    alwaysUpdateLinks = cfg.settings.alwaysUpdateLinks or true;
    vimMode = cfg.settings.vimMode or false;
    newFileLocation = cfg.settings.newFileLocation or "root";
    attachmentFolderPath = cfg.settings.attachmentFolderPath or "Attachments";
    showInlineTitle = cfg.settings.showInlineTitle or true;
    strictLineBreaks = cfg.settings.strictLineBreaks or false;
  };

  appearanceConfig = {
    theme = cfg.settings.theme or "moonstone";
    cssTheme = cfg.settings.cssTheme or "";
    baseFontSize = cfg.settings.baseFontSize or 16;
    accentColor = cfg.settings.accentColor or "";
    monospaceFontFamily = cfg.settings.monospaceFontFamily or "";
    textFontFamily = cfg.settings.textFontFamily or "";
    translucency = cfg.settings.translucency or false;
    showViewHeader = cfg.settings.showViewHeader or true;
    showRibbon = cfg.settings.showRibbon or true;
  };

  communityPluginsConfig = builtins.attrNames cfg.plugins;

in {
  options.programs.obsidian = {
    enable = mkEnableOption "Obsidian configuration management";
    
    vaultPath = mkOption {
      type = types.str;
      description = "Path to the Obsidian vault";
      example = "/Users/ludwig/obsidian_vaults/personal";
    };
    
    plugins = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          url = mkOption {
            type = types.str;
            description = "URL to download the plugin zip/tar file";
            example = "https://github.com/readwiseio/obsidian-readwise/archive/refs/tags/3.0.1.tar.gz";
          };
          sha256 = mkOption {
            type = types.str;
            description = "SHA256 hash of the plugin zip file";
          };
        };
      });
      default = {};
      description = "Obsidian community plugins to install";
    };
    
    settings = mkOption {
      type = types.submodule {
        options = {
          promptDelete = mkOption {
            type = types.bool;
            default = false;
            description = "Prompt before deleting files";
          };
          
          alwaysUpdateLinks = mkOption {
            type = types.bool;
            default = true;
            description = "Always update links when renaming files";
          };
          
          vimMode = mkOption {
            type = types.bool;
            default = false;
            description = "Enable vim key bindings";
          };
          
          newFileLocation = mkOption {
            type = types.enum [ "root" "current" "folder" ];
            default = "root";
            description = "Where to create new files";
          };
          
          attachmentFolderPath = mkOption {
            type = types.str;
            default = "Attachments";
            description = "Folder for attachments";
          };
          
          # appearance.json settings
          theme = mkOption {
            type = types.enum [ "moonstone" "obsidian" ];
            default = "moonstone";
            description = "Light or dark theme";
          };
          
          cssTheme = mkOption {
            type = types.str;
            default = "";
            description = "CSS theme name";
          };
          
          baseFontSize = mkOption {
            type = types.int;
            default = 16;
            description = "Base font size";
          };
          
          accentColor = mkOption {
            type = types.str;
            default = "";
            description = "Accent color";
          };
          
          monospaceFontFamily = mkOption {
            type = types.str;
            default = "";
            description = "Monospace font family";
          };
        };
      };
      default = {};
      description = "Obsidian configuration settings";
    };
  };

  config = mkIf cfg.enable {
    home.file = mkMerge [
      (mkMerge (mapAttrsToList installPlugin cfg.plugins))
      
      {
        "${cfg.vaultPath}/.obsidian/app.json" = {
          text = builtins.toJSON appConfig;
        };
        
        "${cfg.vaultPath}/.obsidian/appearance.json" = {
          text = builtins.toJSON appearanceConfig;
        };
        
        "${cfg.vaultPath}/.obsidian/community-plugins.json" = {
          text = builtins.toJSON communityPluginsConfig;
        };
      }
    ];
  };
} 
