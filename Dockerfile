FROM ubuntu:24.04

# Update the package list and upgrade installed packages
RUN apt-get update -y && apt-get upgrade -y

# Install Python 3 and pip
RUN apt-get install -y python3 python3-pip

# Add the new non-root user 'polyrunner'
RUN useradd -m -s /bin/bash polyrunner

# Set the working directory
WORKDIR /home/polyrunner

# Switch to the non-root user
USER polyrunner

# Set the entrypoint to an infinite sleep
ENTRYPOINT ["tail", "-f", "/dev/null"]
