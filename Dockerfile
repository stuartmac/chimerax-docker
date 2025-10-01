# Use Ubuntu 24.04 LTS as base image to match ChimeraX package
FROM ubuntu:24.04

# Download ChimeraX .deb package from the UCSF website and accept the license agreement
# https://www.cgl.ucsf.edu/chimerax/cgi-bin/secure/chimerax-get.py?file=1.10/ubuntu-24.04/ucsf-chimerax_1.10.1ubuntu24.04_amd64.deb
COPY ucsf-chimerax_1.10.1ubuntu24.04_amd64.deb chimerax.deb

# Install ChimeraX with gdebi and clean up
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y gdebi-core \
    && gdebi --non-interactive chimerax.deb \
    && rm chimerax.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and switch to it
RUN useradd -m chimeraxuser
USER chimeraxuser

# Set the home directory
ENV HOME=/home/chimeraxuser

# Set XDG_RUNTIME_DIR to avoid warning
ENV XDG_RUNTIME_DIR=/tmp/runtime-chimeraxuser

# Set the working directory
VOLUME /data
WORKDIR /data

# Set the entry point to ChimeraX
ENTRYPOINT ["chimerax", "--offscreen"]
