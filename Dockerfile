FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and upgrade installed packages
USER root
RUN apt-get update -y && apt-get upgrade -y

# Update ubuntu user's settings
USER ubuntu
RUN echo '' >> ~/.bashrc
RUN echo 'alias la="ls -A"' >> ~/.bashrc
RUN echo 'alias ll="ls -alF"' >> ~/.bashrc
RUN echo 'alias l="ls -lh"' >> ~/.bashrc
RUN echo 'export PATH="$PATH:/home/ubuntu/.local/bin"' >> ~/.bashrc

# Install tools
USER root
RUN apt-get update -y && apt-get install -y curl wget git htop nano iproute2 net-tools iputils-ping build-essential zip unzip bash-completion

# Install Python 3 and pip
USER root
RUN apt-get update -y && apt-get install -y python3 python3-pip

# Install pipx
USER root
RUN apt-get update -y && apt-get install -y pipx

# Add pipx completions
USER ubuntu
RUN echo 'eval "$(register-python-argcomplete pipx)"' >> ~/.bashrc

# Install Poetry
USER ubuntu
RUN curl -sSL https://install.python-poetry.org | python3 -
RUN bash -li -c "poetry completions bash >> ~/.bash_completion" && rm -f ~/.bash_history

# Install nvm, Node.js, and pnpm
USER ubuntu
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
RUN bash -li -c "nvm install 22 && corepack enable pnpm yarn" && rm -f ~/.bash_history
RUN bash -li -c "yes | pnpm --version ; yes | yarn --version ; exit 0" && rm -f ~/.bash_history

# Install golang
USER root
RUN apt-get update -y && apt-get install -y golang

# Install rust
USER ubuntu
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Switch to the non-root user and change the working directory and run!
USER ubuntu
WORKDIR /home/ubuntu
ENTRYPOINT ["/bin/bash"]
