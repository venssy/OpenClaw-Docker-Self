# 使用构建参数指定基础镜像
ARG BASE_IMAGE=justlikemaki/openclaw-docker-cn-im:latest
FROM ${BASE_IMAGE}

USER root

RUN apt update && apt install -y --no-install-recommends \
    git curl ca-certificates gnupg2 python3 python3-pip && \
    # 添加CUDA源
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/3bf863cc.pub | gpg --dearmor -o /usr/share/keyrings/nvidia-cuda-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nvidia-cuda-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    apt update && apt install -y --no-install-recommends cuda-nvcc-12-8 libcudnn9-dev-cuda-12 && \

ENV PATH="/usr/local/cuda-12/bin:$PATH" \
    LD_LIBRARY_PATH="/usr/local/cuda-12/lib64:$PATH"

    # 安装bun和ModelScope SDK
RUN curl -fsSL https://bun.sh/install | bash

RUN mv /usr/local/bin/qmd /usr/local/bin/qmd.bak && \
    git clone https://github.com/tobilu/qmd.git /qmd && cd /qmd && \
    bun install && bun run build -- --cuda && \
    rm -rf /qmd

RUN qmd status

RUN npm install -g mcporter && chown -R 1000:1000 "/home/node/.npm"

USER node
