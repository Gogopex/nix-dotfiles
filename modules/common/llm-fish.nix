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

        llm-stats = {
          description = "Show token usage stats from LLM logs";
          body = ''
            sqlite3 (llm logs path) "
              SELECT 
                model,
                COUNT(*) as conversations,
                SUM(input_tokens) as total_input,
                SUM(output_tokens) as total_output,
                SUM(input_tokens + output_tokens) as total_tokens
              FROM responses
              GROUP BY model
              ORDER BY total_tokens DESC
            " | column -t -s '|'
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

        explain-error = {
          description = "Explain the last command error";
          body = ''
            set -l last_status $status
            set -l last_cmd (history -1)
            if test $last_status -ne 0
              echo "Command: $last_cmd" | llm -t explain
            else
              echo "Last command succeeded"
            end
          '';
        };

        cmd-helper = {
          description = "Get CLI command for a task";
          body = ''
            set -l task (string join " " $argv)
            llm -t cmd "$task" | tee /dev/tty | pbcopy
            echo ""
            echo "Command copied to clipboard!"
          '';
        };

        llm-chat = {
          description = "Start interactive chat with continuation";
          body = ''
            set -l model $argv[1]
            if test -z "$model"
              set model "5m"
            end
            llm chat -m $model
          '';
        };

        oneliner = {
          description = "Generate Unix one-liner";
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

        llm-stream-test = {
          description = "Test streaming with a model";
          body = ''
            set -l model $argv[1]
            if test -z "$model"
              set model "5m"
            end
            echo "Tell me a haiku about fish" | llm -m $model -s
          '';
        };
      };

      programs.fish.shellAbbrs = {
        ll = "llm";
        llc = "llm-chat";
        llr = "llm logs -r";
        lls = "llm-search";
        llh = "llm logs -n 10";
        gcai = "git-commit-ai";
        cmh = "cmd-helper";
        ol = "oneliner";
      };
    }
  ];
}
