FROM hermantolim/chromium:12.14.0-bionic


USER root
WORKDIR /
COPY ./js /tmp/test
RUN chown -R app:app /tmp/test

USER app
WORKDIR /tmp/test
RUN npm install --production
