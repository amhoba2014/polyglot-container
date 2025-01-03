# Polyglot Container

[![GitHub Repository](https://img.shields.io/badge/GitHub-amhoba2014/polyglot--container-brightgreen)](https://github.com/amhoba2014/polyglot-container)
[![Docker Image](https://img.shields.io/badge/Docker-ghcr.io%2Famhoba2014%2Fpolyglot--container%3Alatest-blue)](https://github.com/amhoba2014/polyglot-container/pkgs/container/polyglot-container)

## Overview
The Polyglot Container is a Docker image designed to provide a comprehensive development environment for multiple programming languages. It is based on Ubuntu 24.04 and includes essential tools such as git, nano, etc. 

The image supports Python, Node.js, Golang, and Rust, making it an ideal solution for developers who work with multiple languages.

## Features
* Based on Ubuntu 24.04
* Includes curl, wget, git, htop, nano, zip, unzip, rar, unrar, network tools and build tools
* Supports multiple programming languages:
	+ Python (v3.12.3), pip, poetry, uv
	+ Node.js (v22.12.0), pnpm, yarn
	+ Golang (v1.22.2)
	+ Rust (v1.83.0)
* Provides a fast and disposable test and development environment
* No `sudo` access is provided to the ubuntu user to keep security burdens high.

## Usage
To use the Polyglot Container, follow these steps:

1. **Pull the image**: Run the following command to pull the latest image from GHCR:
```bash
docker pull ghcr.io/amhoba2014/polyglot-container:latest
```

2. **Run the container**: Once the image is pulled, you can run the container using:
```bash
docker run -it ghcr.io/amhoba2014/polyglot-container:latest
```

This will start a new container from the image and open a shell session.

3. **Develop and test**: You can now use the container as a development environment. The image includes all the necessary tools and languages, so you can start coding and testing your projects immediately.

## Contributing
 Contributions are welcome! If you have any suggestions or improvements, please submit a pull request or issue on the [GitHub repository](https://github.com/amhoba2014/polyglot-container).

<!--
git add -A && git commit -am 'MESSAGE' && git tag -m 'MESSAGE' v1.0.0 && git push --follow-tags
-->

## License
The Polyglot Container is licensed under the [MIT License](https://opensource.org/licenses/MIT). See the [LICENSE](LICENSE) file for details.
