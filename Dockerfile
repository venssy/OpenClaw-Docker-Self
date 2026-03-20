# 使用构建参数指定基础镜像
ARG BASE_IMAGE=justlikemaki/openclaw-docker-cn-im:latest
FROM ${BASE_IMAGE}

USER root

RUN apt update && apt install -y --no-install-recommends \
    git curl ca-certificates gnupg2 python3 python3-pip && \
    # 添加CUDA源
    # curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/3bf863cc.pub | gpg --dearmor -o /usr/share/keyrings/nvidia-cuda-keyring.gpg && \
    # echo "deb [signed-by=/usr/share/keyrings/nvidia-cuda-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    # apt update && apt install -y --no-install-recommends cuda-nvcc-13-0 libcudnn9-dev-cuda-13 vulkan-tools libvulkan-dev spirv-tools && \
    rm -rf /var/lib/apt/lists/*

# ENV PATH="/usr/local/cuda-13/bin:$PATH"
# ENV LD_LIBRARY_PATH="/usr/local/cuda-13/lib64:$PATH"

    # 安装bun和ModelScope SDK
# RUN curl -fsSL https://bun.sh/install | bash

# RUN mv /usr/local/bin/qmd /usr/local/bin/qmd.bak && \
#     bun install -g https://github.com/tobi/qmd
#    git clone https://github.com/tobi/qmd.git /qmd && cd /qmd && \
#    bun install && bun run build -- --cuda && \
#    rm -rf /qmd

ENV NODE_LLAMA_CPP_GPU=false

RUN npm install -g qmd

# RUN qmd status

RUN npm install -g mcporter && chown -R 1000:1000 "/home/node/.npm"

USER node
