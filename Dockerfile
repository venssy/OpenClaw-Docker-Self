# 使用构建参数指定基础镜像
ARG BASE_IMAGE=justlikemaki/openclaw-docker-cn-im:latest
FROM ${BASE_IMAGE}

USER root

RUN npm install -g mcporter

USER node
