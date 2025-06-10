let
  ludwig = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPz8u9LQGVSvApesN1SVrYPohZVsXpG4DwKsbYt4SBLA ludovicpouey@Ludwigs-MacBook-Pro.local";
  system = ludwig; # Use the same key for system for now
in
{
  "secrets/anthropic-api-key.age".publicKeys = [ ludwig system ];
  "secrets/openai-api-key.age".publicKeys = [ ludwig system ];
  "secrets/gemini-api-key.age".publicKeys = [ ludwig system ];
  "secrets/deepseek-api-key.age".publicKeys = [ ludwig system ];
}