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

## Examples

### Generating an Image

To generate an image of a molecular structure:

1. Place your molecular structure file (e.g., `test.pdb`) in your current working directory.
2. Run the following command:

```bash
docker run -v $(pwd):/data chimerax:latest --script "open /data/test.pdb; save /data/output_image.png"
```

This will create an image `output_image.png` in your current directory.

## Contributing

Contributions are welcome! If you have suggestions for improvements or encounter any issues, please open an issue or submit a pull request.

## License and Disclaimer
This Dockerfile and associated scripts are provided under the MIT License. However, the use of UCSF ChimeraX software installed by this Dockerfile is subject to the terms and conditions set by the University of California, San Francisco (UCSF). It is the responsibility of the users to comply with these terms.

Please note that this Dockerfile is a tool to facilitate the installation of ChimeraX in a Docker container, and does not include ChimeraX software itself. Users must download the ChimeraX package on their own from the official UCSF ChimeraX website and are responsible for adhering to ChimeraX's licensing terms.

For more information about ChimeraX's licensing terms, please refer to the official ChimeraX license documentation.

## Acknowledgments

- Thanks to the UCSF ChimeraX team for providing a powerful tool for molecular visualization and analysis.
