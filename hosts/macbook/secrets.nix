{ ... }: {
  age.secrets = {
    anthropic-api-key.file = ../../secrets/anthropic-api-key.age;
    openai-api-key.file    = ../../secrets/openai-api-key.age;
    gemini-api-key.file    = ../../secrets/gemini-api-key.age;
    deepseek-api-key.file  = ../../secrets/deepseek-api-key.age;
  };
}