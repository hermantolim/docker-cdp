FROM ubuntu:bionic

COPY ./dpkg-conf.sh /tmp/dpkg-conf.sh
COPY ./skel /etc/skel
RUN /tmp/dpkg-conf.sh \
    && apt-get -qqy update \
    && apt-get -qy --no-install-recommends install chromium-browser \
    && rm -rf /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /tmp/* /usr/share/{doc,man,doc-base,gtk-doc,info,groff,lintian,linda}/* \
        /usr/share/{applications,menu,appdata,gnome-control*,menu,themes,bash-completion}/*

RUN useradd -G video,audio -m -d /app app

USER app
WORKDIR /app

CMD ["/bin/bash"]