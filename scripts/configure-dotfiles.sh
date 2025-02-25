#!/bin/bash

set -ouex pipefail

cd /tmp || exit

git clone https://github.com/reisaraujo-miguel/my-dot-files.git

cd my-dot-files || exit

# configure system wide
cp -r .zshenv /etc/zshenv || exit
cp -r .gitconfig /etc/gitconfig || exit
cp -r .config/* /etc || exit

# configure new users
mkdir -p /etc/skel

cp -r .zshenv .gitconfig .config /etc/skel || exit

cd / || exit
