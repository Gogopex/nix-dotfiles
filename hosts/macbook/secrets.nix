{ ... }: {
  age.secrets = {
    anthropic-api-key = {
      file = ../../secrets/anthropic-api-key.age;
      mode = "444";
    };
    openai-api-key = {
      file = ../../secrets/openai-api-key.age;
      mode = "444";
    };
    gemini-api-key = {
      file = ../../secrets/gemini-api-key.age;
      mode = "444";
    };
    deepseek-api-key = {
      file = ../../secrets/deepseek-api-key.age;
      mode = "444";
    };
  };
}
