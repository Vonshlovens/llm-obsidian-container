FROM node:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nano \
    zsh \
    fonts-powerline \
    && rm -rf /var/lib/apt/lists/*

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k theme for Oh My Zsh
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k

# Copy pre-configured .zshrc
COPY .zshrc.sh /root/.zshrc

# Install global npm packages
RUN npm install -g @google/gemini-cli
RUN npm install -g @openai/codex
RUN npm install -g @anthropic-ai/claude-code

# Create codex config directory and file
RUN mkdir -p /root/.codex && \
    echo '[default]' > /root/.codex/config.toml && \
    echo 'model = "gpt-5-codex"' >> /root/.codex/config.toml && \
    echo 'model_provider = "azure"' >> /root/.codex/config.toml && \
    echo 'model_reasoning_effort = "medium"' >> /root/.codex/config.toml && \
    echo '' >> /root/.codex/config.toml && \
    echo '[model_providers.azure]' >> /root/.codex/config.toml && \
    echo 'name = "Azure OpenAI"' >> /root/.codex/config.toml && \
    echo 'base_url = "https://eevan-mayebc2b-eastus2.openai.azure.com/openai/v1"' >> /root/.codex/config.toml && \
    echo 'env_key = "AZURE_OPENAI_API_KEY"' >> /root/.codex/config.toml && \
    echo 'wire_api = "responses"' >> /root/.codex/config.toml

# Set zsh as default shell
ENV SHELL=/bin/zsh

# Set working directory
WORKDIR /workspace

# Default command
CMD ["zsh"]
