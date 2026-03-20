# 使用构建参数指定基础镜像
ARG BASE_IMAGE=justlikemaki/openclaw-docker-cn-im:latest
FROM ${BASE_IMAGE}

USER root

RUN apt update && apt install -y --no-install-recommends \
    git curl ca-certificates gnupg2 python3 python3-pip cmake g++ && \
    # 添加CUDA源
    # curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/3bf863cc.pub | gpg --dearmor -o /usr/share/keyrings/nvidia-cuda-keyring.gpg && \
    # echo "deb [signed-by=/usr/share/keyrings/nvidia-cuda-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    # apt update && apt install -y --no-install-recommends cuda-nvcc-13-0 libcudnn9-dev-cuda-13 vulkan-tools libvulkan-dev spirv-tools && \
    rm -rf /var/lib/apt/lists/*

# ENV PATH="/usr/local/cuda-13/bin:$PATH"
# ENV LD_LIBRARY_PATH="/usr/local/cuda-13/lib64:$PATH"

    # 安装bun和ModelScope SDK
RUN curl -fsSL https://bun.sh/install | bash

# RUN mv /usr/local/bin/qmd /usr/local/bin/qmd.bak && \
#     bun install -g https://github.com/tobi/qmd
#    git clone https://github.com/tobi/qmd.git /qmd && cd /qmd && \
#    bun install && bun run build -- --cuda && \
#    rm -rf /qmd

ENV NODE_LLAMA_CPP_GPU=false

RUN npm install -g qmd && sed -i 's#hf:ggml-org/embeddinggemma-300M-GGUF/embeddinggemma-300M-Q8_0.gguf#hf:wangjinzzhong/bge-small-en-v1.5-Q4_K_M-GGUF/bge-small-en-v1.5-q4_k_m.gguf#;s#hf:ggml-org/Qwen3-0.6B-GGUF/Qwen3-0.6B-Q8_0.gguf#hf:Qwen/Qwen2.5-0.5B-Instruct-GGUF/qwen2.5-0.5b-instruct-q4_k_m.gguf#' /usr/local/lib/node_modules/@tobilu/qmd/dist/llm.js

RUN qmd status

RUN npm install -g mcporter && chown -R node:node "/home/node"

USER node

RUN mkdir test && cd test && echo hello > test.md && qmd collection add . --name test && qmd embed && qmd query "hello"