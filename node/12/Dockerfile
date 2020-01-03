FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive LC_ALL=C
COPY ./ /tmp/build
RUN /tmp/build/build.sh \
    && rm -rf /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /tmp/* /usr/share/{doc,man,doc-base,gtk-doc,info,groff,lintian,linda}/* \
        /usr/share/{applications,menu,appdata,gnome-control*,menu,themes,bash-completion}/* \
        /usr/bin/mkfs* /bin/mkfs* /usr/bin/z{less,grep,cat}* /bin/z{less,grep,cat}*

ENTRYPOINT ["dump-init", "--", "entrypoint.sh"]

CMD ["node"]