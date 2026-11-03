FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99

# Base packages + dependencies + desktop + Chromium + AnyDesk
RUN apt update && apt install -y \
    openssh-server \
    sudo \
    python3 \
    python3-pip \
    xvfb \
    x11-utils \
    wget \
    curl \
    nano \
    lxde \
    openbox \
    lxterminal \
    chromium-browser \
    chromium-chromedriver \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    libxt6 \
    libasound2t64 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxshmfence1 \
    libnss3 \
    libnspr4 \
    libxext6 \
    libxrender1 \
    fonts-liberation \
    libpolkit-gobject-1-0 \
    && mkdir -p /var/run/sshd \
    && echo 'root:password' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# AnyDesk
RUN wget -O /tmp/anydesk.deb https://download.anydesk.com/linux/anydesk_6.3.2-1_amd64.deb \
    && apt install -y /tmp/anydesk.deb \
    && rm /tmp/anydesk.deb

# User
RUN useradd -m -s /bin/bash user && echo 'user:password' | chpasswd && adduser user sudo

# Startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22

CMD ["/start.sh"]
