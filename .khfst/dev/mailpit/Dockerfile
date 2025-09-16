# --- load image
FROM axllent/mailpit:latest 

# --- switch to root user 
USER root

# --- create certificates directory
RUN mkdir -p /home/root/certs

# --- set up permissions
RUN chown -R root:root /home/root/certs 
RUN chmod 700 /home/root/certs

# --- set up working directory
WORKDIR /home/root/
