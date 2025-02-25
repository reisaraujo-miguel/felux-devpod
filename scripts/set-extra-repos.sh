#!/bin/bash

set -ouex pipefail

dnf5 -y install 'dnf5-command(copr)'

file=$(cat "${BUILD_FILES_DIR}/copr-repos")

for repo in $file; do
	echo "Enabling Copr repository: $repo"
	if ! dnf5 -y copr enable "$repo"; then
		echo "Error: Failed to enable repository: $repo" >&2
		exit 1
	fi
done

dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras}

dnf5 -y config-manager setopt "*terra*".priority=3
dnf5 -y config-manager setopt "*terra*".exclude="nerd-fonts topgrade"
