ARG EXIM_UBUNTU_VERSION

FROM $EXIM_UBUNTU_VERSION

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y exim4 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y whois && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y exim4-daemon-heavy && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y pamtester && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


EXPOSE 25

# COPY exim.conf /etc/exim4/exim4.conf.template
# CMD ["exim4", "-bd", "-q15m", "-v"]
