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
RUN echo 'export PATH="$PATH:/home/ubuntu/.local/bin"' >> ~/.bashrc

# Install Python 3, pip, curl and wget
USER root
RUN apt-get install -y python3 python3-pip curl wget

# Install pipx
USER ubuntu
RUN pip3 install pipx
RUN pipx ensurepath

# Install Poetry
USER ubuntu
RUN curl -sSL https://install.python-poetry.org | python3 -
RUN poetry completions bash >> ~/.bash_completion

# Install nvm, Node.js, and pnpm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && \
    nvm install 22 && \
    corepack enable pnpm

# Switch to the non-root user and change the working directory and run!
USER ubuntu
WORKDIR /home/ubuntu
ENTRYPOINT ["/bin/bash"]
