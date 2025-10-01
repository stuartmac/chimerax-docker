# Use Ubuntu 22.04 LTS as base image
FROM ubuntu:22.04

# Download ChimeraX .deb package from the UCSF website and accept the license agreement
# https://www.cgl.ucsf.edu/chimerax/cgi-bin/secure/chimerax-get.py?file=1.7/ubuntu-22.04/ucsf-chimerax_1.7.1ubuntu22.04_amd64.deb
COPY ucsf-chimerax_1.7.1ubuntu22.04_amd64.deb chimerax.deb

# Install ChimeraX with gdebi and clean up
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y gdebi-core \
    && gdebi --non-interactive chimerax.deb \
    && rm chimerax.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy and set up entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the working directory
VOLUME /data
WORKDIR /data

# Set the entry point to our wrapper script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
