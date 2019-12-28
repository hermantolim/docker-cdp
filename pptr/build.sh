#!/bin/bash

exec 2>&1

set -e
set -x

apt-get -qqy update
apt-get -qqy upgrade
apt-get -y --no-install-recommends install chromium-browser

CHROMIUM_VERSION=$(/usr/lib/chromium-browser/chromium-browser --product-version | cut -d'.' -f1)
eval $(curl -sL -H "Accept: application/json, text/plain" "https://omahaproxy.appspot.com/deps.json?version=$CHROMIUM_VERSION" | sed -E 's#[?, \{\}$]"([^"]+)": "([^"]+)[",\}]+#\U\1=\2\n#gm')

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
export PUPPETEER_CHROMIUM_REVISION=$CHROMIUM_BASE_POSITION

NPM_CHROMIUM_VERSION=$(npm show puppeteer --json | awk -F'"' '/chromium_revision/{print $4}')

if (( $PUPPETEER_CHROMIUM_REVISION != $NPM_CHROMIUM_REVISION )); then
    echo "ERROR: chromium revision number differ"
    echo "CHROMIUM=$CHROMIUM_BASE_POSITION\nNPM_CHROMIUM_REVISION=$NPM_CHROMIUM_REVISION"
    exit 1
fi

npm install -g puppeteer

mkdir -p /etc/skel/.config/chromium/Default
cp /tmp/build/.chromium-browser.init /etc/skel/.chromium-browser.init
cp /tmp/build/.chromium-browser.init /root/.chromium-browser.init
cp /tmp/build/Preferences /etc/skel/.config/chromium/Default/Preferences

chmod -R 0700 /etc/skel/.config/chromium
chmod 0644 /etc/skel/.config/chromium/Default/Preferences

useradd -G audio,video -m -d /app app
chown -R app:app /app

cd /
rm -rf /root/*
rm -rf /tmp/* /var/cache/apt/archives/*.deb
rm -rf /usr/share/{doc,man,doc-base,gtk-doc,info,groff,lintian,linda}
rm -rf /usr/share/{applications,menu,appdata,gnome-control*,menu,themes,bash-completion}