{ config, ... }:

{
  home-manager.sharedModules = [
    {
      programs.broot = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          modal = true;
          show_hidden = false;
          date_time_format = "%Y-%m-%d %R";

          verbs = [
            {
              invocation = "edit";
              shortcut = "e";
              execution = "$EDITOR +{line} {file}";
              leave_broot = false;
            }
            {
              invocation = "create {subpath}";
              shortcut = "c";
              execution = "$EDITOR {directory}/{subpath}";
              leave_broot = false;
            }
            {
              invocation = "view";
              shortcut = "v";
              execution = "bat {file}";
              leave_broot = false;
            }
            {
              invocation = "cd";
              shortcut = "cd";
              execution = ":quit;cd {directory}";
              leave_broot = false;
            }
          ];

          skin = {
            default = "${config.theme.colors.fg1} ${config.theme.colors.bg0} / ${config.theme.colors.fg2} ${config.theme.colors.bg0}";
            tree = "${config.theme.colors.fg4} None / ${config.theme.colors.gray} None";
            file = "${config.theme.colors.fg1} None / ${config.theme.colors.fg2} None";
            directory = "${config.theme.colors.aqua} None Bold / ${config.theme.colors.aqua} None";
            exe = "${config.theme.colors.green} None";
            link = "${config.theme.colors.blue} None";
            pruning = "${config.theme.colors.bg4} None Italic";
            permissions = "${config.theme.colors.fg4} None / ${config.theme.colors.bg4} None";
            size = "${config.theme.colors.fg2} None / ${config.theme.colors.fg3} None";
            dates = "${config.theme.colors.bright_aqua} None / ${config.theme.colors.aqua} None";
            selected_line = "None ${config.theme.colors.bg1} / None ${config.theme.colors.bg2}";
            char_match = "${config.theme.colors.yellow} None";
            file_error = "${config.theme.colors.red} None";
            flag_label = "${config.theme.colors.fg4} None";
            flag_value = "${config.theme.colors.yellow} None Bold";
            input = "${config.theme.colors.fg1} None / ${config.theme.colors.fg2} ${config.theme.colors.bg0_s}";
            status_error = "${config.theme.colors.red} ${config.theme.colors.bg0_s}";
            status_job = "${config.theme.colors.yellow} ${config.theme.colors.bg0_s}";
            status_normal = "${config.theme.colors.fg4} ${config.theme.colors.bg0_s} / ${config.theme.colors.fg4} ${config.theme.colors.bg0_s}";
            status_italic = "${config.theme.colors.yellow} ${config.theme.colors.bg0_s} Italic";
            status_bold = "${config.theme.colors.yellow} ${config.theme.colors.bg0_s} Bold";
            status_code = "${config.theme.colors.green} ${config.theme.colors.bg0_s}";
            status_ellipsis = "${config.theme.colors.fg4} ${config.theme.colors.bg0_s}";
            scrollbar_track = "${config.theme.colors.bg4} None";
            scrollbar_thumb = "${config.theme.colors.fg4} None";
            help_paragraph = "${config.theme.colors.fg2} None";
            help_bold = "${config.theme.colors.yellow} None Bold";
            help_italic = "${config.theme.colors.yellow} None Italic";
            help_code = "${config.theme.colors.green} ${config.theme.colors.bg1}";
            help_headers = "${config.theme.colors.yellow} None";
          };
        };
      };
    }
  ];
}
