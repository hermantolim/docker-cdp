#!/bin/bash

exec 2>&1

set -e
set -x

cat <<EOF >/etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ bionic main universe
deb http://archive.ubuntu.com/ubuntu/ bionic-security main universe
deb http://archive.ubuntu.com/ubuntu/ bionic-updates main universe
EOF

cat <<EOF >/etc/dpkg/dpkg.cfg.d/excludes-extra
path-exclude=*.png
path-exclude=*.jpg
path-exclude=*.svg
path-exclude=/usr/share/man/*
path-exclude=/usr/share/doc/*
path-exclude=/usr/share/X11/locale/*
path-exclude=/usr/share/doc-base/*
path-exclude=/usr/share/locale/*
path-exclude=/usr/share/groff/*
path-exclude=/usr/share/info/*
path-exclude=/usr/share/lintian/*
path-exclude=/usr/share/linda/*
path-exclude=/usr/share/applications/*
path-exclude=/usr/share/icons/*
path-exclude=/usr/share/licenses/*
path-exclude=/usr/share/common-licenses/*
path-exclude=/usr/share/menu/*
path-exclude=/usr/share/gnome-control-center/*
path-exclude=/usr/share/appdata/*
path-exclude=/usr/share/bash-completion/*
path-exclude=/usr/share/themes/*
path-exclude=/usr/share/i18n/*
path-exclude=/usr/share/vim/vim*/lang*
path-exclude=/usr/share/gtk-doc/*
path-exclude=/usr/share/locale-langpack/*
path-exclude=/etc/locale.alias
path-exclude=/*lib/systemd/*
path-exclude=/etc/systemd/system/*

path-include=/usr/share/*locale*/en
path-include=/usr/share/*locale*/en_??
path-include=/usr/share/*locale*/en_??
path-include=/usr/share/i18n/charmaps/UTF-8*
path-include=/usr/share/i18n/locales/*
path-include=/usr/share/*locales/trans*
path-include=/usr/share/*locales/iso*
path-include=/usr/share/*locales/*ctype*
path-include=/usr/share/locale/locale.alias
path-include=/usr/share/X11/locale/locale.alias
path-include=/usr/share/icons/hicolor/scalable
path-include=/usr/share/icons/hicolor/symbolic
path-include=/usr/share/icons/hicolor/cursor
path-include=/usr/share/icons/*/*.theme
path-include=/usr/share/icons/*/*.cache
path-exclude=/opt/google/chrome/default_apps/*
path-exclude=/opt/google/chrome/locales/*
path-include=/opt/google/chrome/locales/en*
EOF

mkdir -p /usr/share/i18n

cat <<EOF >/etc/locale.gen
en_US.UTF-8 UTF-8
EOF

cat <<EOF >/usr/share/i18n/SUPPORTED
en_US.UTF-8 UTF-8
EOF

cat <<EOF >/etc/default/locale
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
EOF

apt-get -qqy update
apt-get -qy --no-install-recommends install gnupg curl

[[ -x /bin/sh ]] && ln -sf /bin/bash /bin/sh
[[ -x /usr/bin/sh ]] && ln -sf /usr/bin/bash

# install nodejs
/bin/bash /tmp/build/nodejs.sh

# install dumb-init & entrypoint.sh
DUMBINIT_VERSION=$(curl "https://github.com/Yelp/dumb-init/releases/latest" -s --head | grep Location | sed -E 's#.*v([0-9\.]+).*#\1#')
curl -sL "https://github.com/Yelp/dumb-init/releases/download/v${DUMBINIT_VERSION}/dumb-init_${DUMBINIT_VERSION}_amd64" -o /usr/local/bin/dump-init
chmod 0755 /usr/local/bin/dump-init
install -Dm755 -t /usr/local/bin /tmp/build/entrypoint.sh

# cleanup
apt-get -y purge --autoremove curl

cd /
rm -rf /root/* /root/.npm
rm -rf /tmp/* /var/cache/apt/archives/*.deb
rm -rf /usr/share/{doc,man,doc-base,gtk-doc,info,groff,lintian,linda,locales/*}
rm -rf /usr/share/{applications,menu,appdata,gnome-control*,menu,themes,bash-completion}
find /var/log/ -type f -exec rm {} \;