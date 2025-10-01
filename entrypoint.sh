#!/bin/bash
set -e

# If running with -u flag (non-root), create necessary directories with proper permissions
if [ "$(id -u)" != "0" ]; then
    # Running as non-root user
    # Create ChiMeraX directories in /tmp instead of home (which may not be writable)
    export HOME=/tmp/chimerax-home-$(id -u)
    mkdir -p "$HOME/.local" "$HOME/.cache"
    export XDG_RUNTIME_DIR=/tmp/runtime-$(id -u)
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR" 2>/dev/null || true
else
    # Running as root - use default behavior
    export HOME=/root
fi

# Execute ChiMeraX with all passed arguments
exec chimerax --offscreen "$@"
