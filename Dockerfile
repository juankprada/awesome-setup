# syntax=docker/dockerfile:1

FROM fedora:38 AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN dnf update -y && \
    dnf install -y curl git ansible

FROM base AS juank
ARG TAGS
RUN groupadd -g 1000 juankprada
RUN useradd juankprada --uid 1000 -g juankprada -p racilwayfe
RUN sudo usermod -aG wheel juankprada
USER juankprada
WORKDIR /home/juankprada

FROM juank
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS awesome-setup.yml"]