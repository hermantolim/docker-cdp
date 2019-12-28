FROM hermantolim/node:12-bionic

ENV DEBIAN_FRONTEND=noninteractive \
    NODE_PATH=/usr/lib/node_modules:/usr/local/lib/node_modules \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

COPY ./ /tmp/build
RUN /tmp/build/build.sh \
    && rm -rf /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /tmp/* /usr/share/{doc,man,doc-base,gtk-doc,info,groff,lintian,linda}/* \
        /usr/share/{applications,menu,appdata,gnome-control*,menu,themes,bash-completion}/*

USER app
WORKDIR /app