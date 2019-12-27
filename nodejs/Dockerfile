FROM hermantolim/chromium:bionic

USER root
WORKDIR /
COPY ./build.sh /tmp/build.sh
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive /tmp/build.sh \
  && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1

USER app
WORKDIR /app