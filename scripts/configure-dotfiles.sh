#!/bin/bash

set -ouex pipefail

cd /tmp || exit

git clone https://github.com/reisaraujo-miguel/my-dot-files.git

cd my-dot-files || exit

ignore_files=("LICENSE" "README.md" ".git" "install.sh")

# configure new users
mkdir -p /etc/skel

for file in * .[!.]*; do
	# Skip if the file doesn't exist (can happen with the wildcards)
    	[ -e "$file" ] || continue

	# Skip . and .. directory entries
    	[[ "$file" == "." || "$file" == ".." ]] && continue
	
	ignore=false
 	for ignored_file in "${ignore_files[@]}"; do
    		if [[ "$file" == "$ignored_file" ]]; then
      			ignore=true
      			break
    		fi
  	done

  	if [[ "$ignore" == false ]]; then
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

# cloning all files
if [ -d \"/etc/skel\" ] && [ \"\$(ls -A /etc/skel)\" ]; then
    cp -r /etc/skel/* /root 2>/dev/null
    # Also copy hidden files
    cp -r /etc/skel/.[!.]* /root 2>/dev/null || true
fi

# preventing script from running again
touch /root/.setuplock
" > /etc/profile.d/setup-root.sh	

cd / || exit
