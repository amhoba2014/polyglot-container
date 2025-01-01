FROM ubuntu:24.04

# Update the package list and upgrade installed packages
RUN apt-get update && apt-get upgrade -y

# Install any additional packages you need
# RUN apt-get install -y package-name

# Add the new non-root user 'polyrunner'
RUN useradd -m -s /bin/bash polyrunner

# Set the working directory
WORKDIR /home/polyrunner

# Switch to the non-root user
USER polyrunner

# Set the entrypoint to an infinite sleep
ENTRYPOINT ["tail", "-f", "/dev/null"]
