{ ... }:
{
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
    gemini-api-gcp-project-id = {
      file = ../../secrets/gemini-api-gcp-project-id.age;
      mode = "444";
    };
    openrouter-api-key = {
      file = ../../secrets/openrouter-api-key.age;
      mode = "444";
    };
    groq-api-key = {
      file = ../../secrets/groq-api-key.age;
      mode = "444";
    };
    glm-api-key = {
      file = ../../secrets/glm-api-key.age;
      mode = "444";
    };
    github-token = {
      file = ../../secrets/github-token.age;
      mode = "444";
    };
  };
}
