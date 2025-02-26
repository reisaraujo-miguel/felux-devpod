#!/bin/bash

set -ouex pipefail

cd /tmp || exit

git clone https://github.com/reisaraujo-miguel/my-dot-files.git

cd my-dot-files || exit

ignore_files=("LICENSE" "README.md" ".git" "install.sh")

# configure new users
mkdir -p /etc/skel

for file in *; do
	ignore=false
 	for ignored_file in "${ignore_files[@]}"; do
    		if [[ "$file" == "./$ignored_file" ]]; then
      			ignore=true
      			break
    		fi
  	done

  	if [[ "$ignore" == false && "$file" != /etc/skel ]]; then
    		cp -r "$file" /etc/skel
  	fi
done

# Configure root user on first login
echo "
# checking if I am root
[ \"\$(id -u)\" -eq 0 ] || exit

# creating root dir if it does not exists
[ ! -d /var/roothome ] && mkdir -p /var/roothome

# checking if this script has already been executed once
[ -f /root/.setuplock ] && exit

# cloning all non ignored files
for file in /etc/skel; do
	cp -r \"\$file\" /root
done

# preventing script from running again
touch /root/.setuplock
" > /etc/profile.d/setup-root.sh	

cd / || exit
