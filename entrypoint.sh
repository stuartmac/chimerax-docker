#!/bin/bash
set -e

# If running with -u flag (non-root), create necessary directories with proper permissions
if [ "$(id -u)" != "0" ]; then
    # Create ChiMeraX directories in /tmp instead of home
    export HOME=/tmp/chimerax-home-$(id -u)
    mkdir -p "$HOME/.local" "$HOME/.cache"
    export XDG_RUNTIME_DIR=/tmp/runtime-$(id -u)
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
fi

# Execute ChiMeraX with all passed arguments
exec chimerax --offscreen "$@"
