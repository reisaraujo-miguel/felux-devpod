#!/bin/bash

set -ouex pipefail

if [[ -d "$SYSTEM_FILES_DIR" ]]; then
    cp -r "$SYSTEM_FILES_DIR"/* / || {
        echo "Failed to copy system files"
        exit 1
    }
else
    echo "Warning: System files directory not found"
fi
