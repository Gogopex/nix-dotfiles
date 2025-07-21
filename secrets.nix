let
  ludwig = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPz8u9LQGVSvApesN1SVrYPohZVsXpG4DwKsbYt4SBLA ludovicpouey@Ludwigs-MacBook-Pro.local";
  system = ludwig;
in
{
  "secrets/anthropic-api-key.age".publicKeys = [
    ludwig
    system
  ];
  "secrets/openai-api-key.age".publicKeys = [
    ludwig
    system
  ];
  "secrets/gemini-api-key.age".publicKeys = [
    ludwig
    system
  ];
  "secrets/deepseek-api-key.age".publicKeys = [
    ludwig
    system
  ];
  "secrets/gemini-api-gcp-project-id.age".publicKeys = [
    ludwig
    system
  ];
  "secrets/openrouter-api-key.age".publicKeys = [
    ludwig
    system
  ];
  "secrets/groq-api-key.age".publicKeys = [
    ludwig
    system
  ];
}
