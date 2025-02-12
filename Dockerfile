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
RUN apt-get update -y && apt-get install -y curl wget git htop nano iproute2 net-tools iputils-ping build-essential zip unzip rar unrar python-is-python3 bash-completion

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

# Install uv
USER ubuntu
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

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

# Install XFCE desktop environment and ui packages
USER root
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    sudo \
    novnc \
    net-tools \
    firefox ;
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb ;
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb && rm ./google-chrome-stable_current_amd64.deb ;
# # Add the user to the sudoers group
# RUN groupadd sudoers
# RUN usermod -aG sudoers ubuntu
# RUN echo "%sudoers ALL=(ALL:ALL) ALL" > /etc/sudoers.d/sudoers && \
#     chmod 0440 /etc/sudoers.d/sudoers

# Set XFCE terminal as the default terminal emulator
USER root
RUN update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper

# Run!
USER root
ADD ./startup.py /startup.py
WORKDIR /
ENTRYPOINT ["/bin/bash", "-c", "python3 /startup.py --step-1-root && sudo -u ubuntu python3 /startup.py --step-2-user"]
