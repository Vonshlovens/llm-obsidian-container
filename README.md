# llm-obsidian-container
A container with the main coding agents pre-installed, and a volume mount for your Obsidian vault.

## What’s inside
- Node (latest)
- zsh + Oh My Zsh + powerlevel10k, autosuggestions, syntax highlighting
- CLIs:
  - Google Gemini CLI (`@google/gemini-cli`)
  - OpenAI Codex CLI (`@openai/codex`) with an Azure-oriented default config
  - Claude Code CLI (`@anthropic-ai/claude-code`)
- Quality-of-life tools: git, curl, nano, build-essential, python3

## Quick start
Prereqs: Docker + Docker Compose v2.

```bash
git clone https://github.com/Vonshlovens/llm-obsidian-container.git
cd llm-obsidian-container

# Optional: provide API keys via a local .env file
# echo 'AZURE_OPENAI_API_KEY=...' >> .env
# echo 'GOOGLE_API_KEY=...' >> .env
# echo 'GOOGLE_GENAI_USE_VERTEXAI=true' >> .env

docker compose build dev
docker compose up -d dev
docker compose exec dev zsh -l
```

- Host folder is mounted at `/workspace` inside the container.
- Ports exposed: 3000, 5173, 8080.

## Mount your Obsidian vault
This repo’s `docker-compose.yml` binds your current directory to `/workspace`. To work directly with your vault:
- Option A: Run the compose commands from your vault directory.
- Option B: Edit `docker-compose.yml` to point the `source:` to your vault path, e.g.:
  ```yaml
  volumes:
    - type: bind
      source: /absolute/path/to/your/vault
      target: /workspace
  ```

## Configure API keys
You can use environment variables or a `.env` file in the repo root (auto-loaded by Compose):
- `AZURE_OPENAI_API_KEY` for the Codex config at `~/.codex/config.toml`
- `GOOGLE_API_KEY` and `GOOGLE_GENAI_USE_VERTEXAI=true` for Gemini

Inside the container:
- Verify CLIs:
  ```bash
  gemini --help
  codex --help
  claude-code --help
  ```
- The default Codex config is at `~/.codex/config.toml`. Adjust the `model`, `base_url`, or provider as needed.

## Customization
- UID/GID: adjust `USER_ID`, `GROUP_ID`, and `USERNAME` build args in `docker-compose.yml` to match your host user if needed.
- Default shell and editor can be set via env: `SHELL=/usr/bin/zsh`, `EDITOR=nano`.

## Troubleshooting
- Fonts/icons in prompt: set a Nerd Font (e.g., Meslo LGS NF) in your terminal or VS Code terminal.
- Permission issues on Linux/macOS: align `USER_ID`/`GROUP_ID` with your host user.
- If ports are in use, remove or change mappings in `docker-compose.yml`.

## Remove
```bash
docker compose down -v
docker image rm von-node-dev:latest
```