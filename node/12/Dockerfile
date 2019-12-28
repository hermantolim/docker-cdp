FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive LC_ALL=C
COPY ./ /tmp/build
RUN /tmp/build/build.sh \
    && rm -rf /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /tmp/* /usr/share/{doc,man,doc-base,gtk-doc,info,groff,lintian,linda}/* \
        /usr/share/{applications,menu,appdata,gnome-control*,menu,themes,bash-completion}/*

ENTRYPOINT ["dump-init", "--", "entrypoint.sh"]

CMD ["node"]