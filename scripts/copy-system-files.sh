#!/bin/bash

set -ouex pipefail

if [[ -d "$SYSTEM_FILES_DIR" ]]; then
    cp -r "$SYSTEM_FILES_DIR"/* / || {
        echo "Failed to copy system files"
        exit 1
    }
    
    cp -r "$SYSTEM_FILES_DIR"/etc/skel/.* /etc || {
	echo "Failed to copy configs to root user"
    	exit 1
    }
    ls 
else
    echo "Warning: System files directory not found"
fi
