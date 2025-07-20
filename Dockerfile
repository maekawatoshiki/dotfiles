FROM ubuntu:22.04
ARG USER
ARG UID
ARG GID

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates tzdata sudo locales wget curl iptables supervisor \
    && apt-get clean \
    && update-alternatives --set iptables /usr/sbin/iptables-legacy \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && echo 'Asia/Tokyo' >/etc/timezone

RUN locale-gen en_US.UTF-8  
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

#
# ↓ Docker in Docker (ref. https://github.com/cruizba/ubuntu-dind/blob/083bb8b7474d528ae75058079346a7a120bf9d2a/ubuntu-jammy.Dockerfile)
#

ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=27.0.3 \
    DOCKER_COMPOSE_VERSION=v2.28.1 \
    BUILDX_VERSION=v0.14.0 \
    DEBUG=false

# Docker and buildx installation
RUN set -eux; \
    \
    arch="$(uname -m)"; \
    case "$arch" in \
        # amd64
        x86_64) dockerArch='x86_64' ; buildx_arch='linux-amd64' ;; \
        # arm32v6
        armhf) dockerArch='armel' ; buildx_arch='linux-arm-v6' ;; \
        # arm32v7
        armv7) dockerArch='armhf' ; buildx_arch='linux-arm-v7' ;; \
        # arm64v8
        aarch64) dockerArch='aarch64' ; buildx_arch='linux-arm64' ;; \
        *) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;;\
    esac; \
    \
    if ! wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then \
        echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
        exit 1; \
    fi; \
    \
    tar --extract \
        --file docker.tgz \
        --strip-components 1 \
        --directory /usr/local/bin/ \
    ; \
    rm docker.tgz; \
    if ! wget -O docker-buildx "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.${buildx_arch}"; then \
        echo >&2 "error: failed to download 'buildx-${BUILDX_VERSION}.${buildx_arch}'"; \
        exit 1; \
    fi; \
    mkdir -p /usr/local/lib/docker/cli-plugins; \
    chmod +x docker-buildx; \
    mv docker-buildx /usr/local/lib/docker/cli-plugins/docker-buildx; \
    \
    dockerd --version; \
    docker --version; \
    docker buildx version

COPY dind/modprobe /usr/local/bin/modprobe
COPY dind/start-docker.sh /usr/local/bin/start-docker.sh
COPY dind/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY dind/supervisor/ /etc/supervisor/conf.d/
COPY dind/logger.sh /opt/bash-utils/logger.sh

RUN chmod +x /usr/local/bin/start-docker.sh \
    /usr/local/bin/entrypoint.sh \
    /usr/local/bin/modprobe

VOLUME /var/lib/docker

# Docker compose installation
RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose && docker-compose version

# Create a symlink to the docker binary in /usr/local/lib/docker/cli-plugins
# for users which uses 'docker compose' instead of 'docker-compose'
RUN ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

#
# ↑ Docker in Docker
#

RUN set -x \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/ALL \
    && groupadd -o \
        --gid ${GID} \
        ${USER} \
    && useradd \
        --uid ${UID} \
        --gid ${GID} \
        --home-dir /home/${USER} \
        --create-home \
        --shell /bin/zsh \
        ${USER} \
    && chown ${USER} -R /home/${USER}

RUN groupadd -g 999 docker \
    && usermod -aG docker ${USER}

USER ${USER}

WORKDIR /home/${USER}

COPY --chown=${USER}:${USER} . dotfiles

WORKDIR /home/${USER}/dotfiles

RUN ./setup.sh

CMD ["/bin/zsh"]
