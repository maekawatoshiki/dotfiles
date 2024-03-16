FROM ubuntu:22.04
ARG USER
ARG UID
ARG GID

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates tzdata sudo locales \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && echo 'Asia/Tokyo' >/etc/timezone

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN set -x \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/ALL \
    && groupadd \
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

USER ${USER}

WORKDIR /home/${USER}

COPY --chown=${USER}:${USER} . dotfiles

WORKDIR /home/${USER}/dotfiles

RUN ./setup.sh

CMD ["/bin/zsh"]
