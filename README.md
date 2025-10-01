# ChimeraX Docker Container

This repository provides a Docker container for [UCSF ChimeraX](https://www.cgl.ucsf.edu/chimerax/), a powerful tool for interactive visualization and analysis of molecular structures and related data. The Docker container allows for running ChimeraX in environments where a GUI is not available.

## Features

- Based on Ubuntu 22.04 LTS.
- Supports running ChimeraX in offscreen mode for generating images and executing scripts without a GUI.

## Prerequisites

Before you begin, ensure you have Docker installed on your system. Instructions for installing Docker can be found on the [official Docker documentation](https://docs.docker.com/get-docker/).

You will also need to download the ChimeraX installation file from the [official ChimeraX website](https://www.cgl.ucsf.edu/chimerax/download.html) and place this in the same directory as the Dockerfile.

The Dockerfile in this repository uses the `ucsf-chimerax_1.7.1ubuntu22.04_amd64.deb`. If you have a different version, you will need to modify the `Dockerfile` accordingly.

## Getting Started

Since the ChimeraX license does not permit redistribution, to use this container you will need to build it directly from this repository.

### Building the Image Locally

Clone the repository, download ChimeraX and navigate to the directory containing the Dockerfile:

```bash
git clone https://github.com/stuartmac/chimerax-docker.git
cd chimerax-docker
```

Build the Docker image:

```bash
docker build -t chimerax:latest .
```

### Running the Container

To run ChimeraX in the container:

```bash
docker run -it --rm -v $(pwd):/data chimerax:latest
```

For generating images in offscreen mode, ensure you mount a volume that contains your data files and where you want the output files to be stored:

```bash
docker run -v $(pwd):/data chimerax:latest --cmd "open 2gbp; save /data/2gbp.png"
```

For running scripts in offscreen mode, use `--script` flags:

```bash
docker run -v $(pwd):/data chimerax:latest --script /data/demo-script.cxc
```

**For Network/Shared Drives (NFS, SMB, etc.):** If you're using a network-mounted or shared drive with root squashing enabled, run the container as your host user to avoid permission issues:

```bash
docker run --user $(id -u):$(id -g) -v $(pwd):/data chimerax:latest --cmd "open 2gbp; save /data/2gbp.png"
```

If you encounter a `setgroups: invalid argument` error, try using only the user ID without the group:

```bash
docker run --user $(id -u) -v $(pwd):/data chimerax:latest --cmd "open 2gbp; save /data/2gbp.png"
```

**Note on File Permissions:** 
- **Local directories:** The container runs as root by default, which works for most local filesystems. Docker Desktop (macOS/Windows) automatically maps file ownership to your host user.
- **Network-mounted drives (NFS with root squash):** Use the `--user $(id -u)` flag to run as your host user. The entrypoint script will configure ChiMeraX to work with your user ID.

## Examples

### Generating an Image

To generate an image of a molecular structure:

1. Place your molecular structure file (e.g., `test.pdb`) in your current working directory.
2. Run the following command:

```bash
docker run -v $(pwd):/data chimerax:latest --script "open /data/test.pdb; save /data/output_image.png"
```

This will create an image `output_image.png` in your current directory.

## Troubleshooting

### Permission Denied Errors

If you encounter "Permission denied" errors when trying to save files, this is typically due to **network-mounted or shared drives with root squashing** (a common NFS security feature).

**Quick Fix:** Use the `--user` flag to run as your host user:
```bash
docker run --user $(id -u):$(id -g) -v $(pwd):/data chimerax:latest --cmd "open 2gbp; save /data/test.png"
```

If you get a `setgroups: invalid argument` error, use only the user ID:
```bash
docker run --user $(id -u) -v $(pwd):/data chimerax:latest --cmd "open 2gbp; save /data/test.png"
```

**Understanding the Issue:**

1. **Root Squashing on NFS**: Many shared/network drives map container root (UID 0) to an unprivileged user (`nobody`), preventing write access.

2. **The `setgroups` Error**: If you see `unable to setup user: setgroups: invalid argument`, this means your host GID doesn't exist in the container. Using only `--user $(id -u)` (without the GID) avoids this issue while still running as your user.

3. **Test in local directory first**: To isolate the issue, try running in your home directory:
   ```bash
   cd ~/test-chimerax
   docker run -v $(pwd):/data chimerax:latest --cmd "open 2gbp; save /data/test.png"
   ```

3. **Check if you're on a network mount**:
   ```bash
   df -T $(pwd)  # Look for nfs, cifs, smb in the Type column
   ```

4. **Verify directory permissions**:
   ```bash
   ls -ld $(pwd)  # Should be writable by your user
   ```

**File Ownership:**
- Without `--user` flag: Files owned by root (or `nobody` on NFS with root squash)
- With `--user $(id -u)`: Files owned by your host user

## Contributing

Contributions are welcome! If you have suggestions for improvements or encounter any issues, please open an issue or submit a pull request.

## License and Disclaimer
This Dockerfile and associated scripts are provided under the MIT License. However, the use of UCSF ChimeraX software installed by this Dockerfile is subject to the terms and conditions set by the University of California, San Francisco (UCSF). It is the responsibility of the users to comply with these terms.

Please note that this Dockerfile is a tool to facilitate the installation of ChimeraX in a Docker container, and does not include ChimeraX software itself. Users must download the ChimeraX package on their own from the official UCSF ChimeraX website and are responsible for adhering to ChimeraX's licensing terms.

For more information about ChimeraX's licensing terms, please refer to the official ChimeraX license documentation.

## Acknowledgments

- Thanks to the UCSF ChimeraX team for providing a powerful tool for molecular visualization and analysis.
