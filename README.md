# musical-system
## my first ai sandbox
#.devcontainer/container-compose.yml
version: "3.9"

services:
  model-server:
    build:
      context: ../model-container
      dockerfile: Containerfile
    container_name: ai-model
    networks:
      - ai-net
    volumes:
      - model-data:/models:ro
    command: >
      bash -c "./llama.cpp/main
      -m /models/llama-3.2-3b-instruct.gguf
      --port 8080
      --host 0.0.0.0"
    ports:
      - "8080:8080"

  supervisor:
    build:
      context: ../supervisor-container
      dockerfile: Containerfile
    container_name: ai-supervisor
    networks:
      - ai-net
    volumes:
      - workspace:/workspace
      - logs:/logs
    environment:
      MODEL_URL: "http://ai-model:8080"
    depends_on:
      - model-server

networks:
  ai-net:

volumes:
  model-data:
  workspace:
  logs:
===========================================
#.devcontainer/devcontainer.json
{
  "name": "AI Lab",
  "dockerComposeFile": "container-compose.yml",
  "service": "supervisor",
  "workspaceFolder": "/workspace",
  "shutdownAction": "stopCompose",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-vscode.remote-containers"
      ]
    }
  }
}
=================================
#model-container/Containerfile
FROM ubuntu:22.04

# System deps
RUN apt-get update && apt-get install -y \
    build-essential cmake git curl \
    && rm -rf /var/lib/apt/lists/*

# llama.cpp
RUN git clone https://github.com/ggerganov/llama.cpp /opt/llama.cpp && \
    cd /opt/llama.cpp && make -j

# Model directory
RUN mkdir -p /models
VOLUME ["/models"]

WORKDIR /opt/llama.cpp
EXPOSE 8080

CMD ["bash"]
===================================================
model-container/models/
===================================================
#supervisor-container/Containerfile
FROM ubuntu:22.04

# System deps
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv \
    curl git bash \
    && rm -rf /var/lib/apt/lists/*

# Python env
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Python deps
RUN pip install --upgrade pip && \
    pip install requests

# Directories
RUN mkdir -p /workspace /tools /logs /supervisor

WORKDIR /workspace
================================================
ai-lab/
  model-container/
    Containerfile
    models/
      llama-3.2-3b-instruct.gguf

  supervisor-container/
    Containerfile
    supervisor/
      loop.py
      router.py
      safety.py
    tools/
      run.sh
      read.sh
      write.sh
    workspace/
    logs/

  .devcontainer/
    devcontainer.json
    container-compose.yml
====================================
You now have:
a model container

a supervisor container

a compose file

a devcontainer config

a clean, modular, future‑proof architecture

If you want, I can now generate:

loop.py (supervisor agent loop)

tool contract scripts

a model download script

a test prompt script

Just tell me what you want next.
