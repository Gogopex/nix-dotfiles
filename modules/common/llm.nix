{
  config,
  lib,
  pkgs,
  ...
}:
{
  home-manager.sharedModules = [
    {
      xdg.configFile."io.datasette.llm/config.json".text = builtins.toJSON {
        default_model = "gpt-5-mini";
        aliases = {
          "ds3" = "deepseek-v3";
          "deepseek" = "deepseek-v3";
          "kimi" = "kimi-k2";
          "k2" = "kimi-k2";
          "5n" = "gpt-5-nano";
          "5m" = "gpt-5-mini";
          "5" = "gpt-5";
        };
      };

      xdg.configFile."io.datasette.llm/templates/dive.yaml".text = ''
        name: dive
        system: |
          You are an expert at creating comprehensive, deeply-nested hierarchical overviews of complex domains.
          Create extremely detailed ASCII hierarchies with many levels of nesting.
          Use clear indentation and ASCII tree characters (├─, └─, │) for structure.
          Make the hierarchy as comprehensive and deeply nested as possible.
        prompt: |
          Give a broad overview of all the most relevant concepts and principles in $input in hierarchical order using ASCII. Make the hierarchy extremely deeply nested.
      '';

      xdg.configFile."io.datasette.llm/templates/cmd.yaml".text = ''
        name: cmd
        system: |
          You are a CLI command expert. 
          Output only the command or pipeline that accomplishes the task.
          Use pipes, redirects, and command chaining as needed.
          Prefer one-liners when possible.
          No explanations unless specifically asked.
          Focus on practical, working commands for unix-like systems.
        prompt: |
          $input
        model: gpt-5-nano
      '';

      xdg.configFile."io.datasette.llm/templates/commit.yaml".text = ''
        name: commit
        system: |
          Generate a concise, descriptive git commit message.
          Follow conventional commit format when appropriate.
          Be specific about what changed.
          Max 50 chars for subject line.
        prompt: |
          Generate a commit message for these changes:
          $input
        model: gpt-5-nano
      '';

      xdg.configFile."io.datasette.llm/templates/fix.yaml".text = ''
        name: fix
        system: |
          You are a code error fixer.
          Output only the corrected code.
          No explanations unless the fix is non-obvious.
          Preserve formatting and style.
        prompt: |
          Fix this code/error:
          $input
        model: gpt-5-mini
      '';

      xdg.configFile."io.datasette.llm/templates/explain.yaml".text = ''
        name: explain
        system: |
          Explain code or technical concepts clearly and concisely.
          Use examples when helpful.
          Focus on the "why" not just the "what".
          Assume technical audience.
        prompt: |
          Explain:
          $input
        model: gpt-5-mini
      '';

      xdg.configFile."io.datasette.llm/templates/regex.yaml".text = ''
        name: regex
        system: |
          Generate regex patterns.
          Output only the regex pattern.
          Add a comment line starting with # explaining what it matches.
          Test against common edge cases.
        prompt: |
          Create a regex for: $input
        model: gpt-5-nano
      '';

      xdg.configFile."io.datasette.llm/templates/sql.yaml".text = ''
        name: sql
        system: |
          Generate SQL queries.
          Use standard SQL unless a specific dialect is mentioned.
          Format for readability.
          Include comments for complex logic.
        prompt: |
          $input
        model: gpt-5-mini
      '';

      xdg.configFile."io.datasette.llm/templates/jq.yaml".text = ''
        name: jq
        system: |
          Generate jq expressions for JSON processing.
          Output only the jq expression.
          Add a comment line starting with # explaining what it does.
          Handle edge cases like missing keys.
        prompt: |
          Create a jq expression to: $input
        model: gpt-5-nano
      '';

      xdg.configFile."io.datasette.llm/templates/oneliner.yaml".text = ''
        name: oneliner
        system: |
          Create powerful Unix one-liners.
          Combine tools like awk, sed, grep, xargs, parallel, etc.
          Optimize for efficiency and elegance.
          Output only the command.
        prompt: |
          $input
        model: gpt-5-nano
      '';
    }
  ];
}