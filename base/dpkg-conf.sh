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