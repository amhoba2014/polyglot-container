FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and upgrade installed packages
USER root
RUN apt-get update -y && apt-get upgrade -y

# Update ubuntu user's settings
USER ubuntu
RUN echo 'alias la="ls -A"' >> ~/.bashrc
RUN echo 'alias ll="ls -alF"' >> ~/.bashrc
RUN echo 'alias l="ls -lh"' >> ~/.bashrc
RUN echo 'export PATH="$PATH:/home/$USER/.local/bin"' >> ~/.bashrc

# Install Python 3, pip, curl and wget
USER root
RUN apt-get install -y python3 python3-pip curl wget

# Install Poetry
USER ubuntu
RUN curl -sSL https://install.python-poetry.org | python3 -

# Switch to the non-root user and change the working directory and run!
USER ubuntu
WORKDIR /home/ubuntu
ENTRYPOINT ["/bin/bash"]
