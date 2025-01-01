FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and upgrade installed packages
USER root
RUN apt-get update -y && apt-get upgrade -y

# Add the new non-root user 'polyrunner'
USER root
RUN useradd -m -s /bin/bash polyrunner
RUN echo 'alias la="ls -A"' >> /home/polyrunner/.bashrc
RUN echo 'alias ll="ls -alF"' >> /home/polyrunner/.bashrc
RUN echo 'alias l="ls -lh"' >> /home/polyrunner/.bashrc
RUN echo 'export PATH="$PATH:/home/$USER/.local/bin"' >> /home/polyrunner/.bashrc
RUN chown polyrunner:polyrunner /home/polyrunner/.bashrc

# Install Python 3, pip, curl and wget
USER root
RUN apt-get install -y python3 python3-pip curl wget

# Install Poetry
USER root
RUN curl -sSL https://install.python-poetry.org | python3 -

# Switch to the non-root user and change the working directory and run!
USER polyrunner
WORKDIR /home/polyrunner
ENTRYPOINT ["/bin/bash"]
