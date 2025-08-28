{
  ...
}:
{
  home-manager.sharedModules = [
    {
      programs.fish.functions = {
        llm-last = {
          description = "Get the last LLM response as plain text";
          body = "llm logs -r";
        };

        llm-search = {
          description = "Search through LLM conversation history";
          body = ''
            set -l query $argv
            llm logs -q "$query" --json | jq -r '.[] | "\n[\(.model)]:\n\(.prompt)\n---\n\(.response)"'
          '';
        };

        git-commit-ai = {
          description = "Generate commit message from staged changes";
          body = ''
            set -l diff (git diff --cached)
            if test -z "$diff"
              echo "No staged changes to commit"
              return 1
            end
            echo "$diff" | llm -t commit | tee /dev/tty | pbcopy
            echo ""
            echo "Commit message copied to clipboard!"
          '';
        };

        llm-chat = {
          description = "Start interactive chat with continuation";
          body = ''
            set -l model $argv[1]
            if test -z "$model"
              set model "gpt5"
            end
            llm chat -m $model
          '';
        };

        oneliner = {
          description = "Generate cmd one-liner";
          body = ''
            set -l task (string join " " $argv)
            llm -t oneliner "$task" | tee /dev/tty | pbcopy
            echo ""
            echo "One-liner copied to clipboard!"
          '';
        };

        llm-export = {
          description = "Export recent conversations to markdown";
          body = ''
            set -l days 7
            if test (count $argv) -gt 0
              set days $argv[1]
            end
            
            sqlite3 (llm logs path) "
              SELECT 
                '## ' || datetime || ' [' || model || ']' || char(10) ||
                '**Prompt:** ' || prompt || char(10) || char(10) ||
                '**Response:** ' || response || char(10) || char(10) ||
                '---' || char(10)
              FROM responses
              WHERE datetime > datetime('now', '-' || $days || ' days')
              ORDER BY datetime DESC
            " > ~/llm-export-(date +%Y%m%d).md
            echo "Exported to ~/llm-export-(date +%Y%m%d).md"
          '';
        };
      };

      # programs.fish.shellAbbrs = {
      #   ll = "llm";
      #   llc = "llm-chat";
      #   llr = "llm logs -r";
      #   lls = "llm-search";
      #   llh = "llm logs -n 10";
      #   gcai = "git-commit-ai";
      #   cmh = "cmd-helper";
      #   ol = "oneliner";
      # };
    }
  ];
}
