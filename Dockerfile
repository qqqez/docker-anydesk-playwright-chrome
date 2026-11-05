FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99

# Podstawowe + zależności + desktop
RUN apt update && apt install -y \
    openssh-server \
    sudo \
    python3 \
    python3-pip \
    python3-venv \
    xvfb \
    x11-utils \
    wget \
    curl \
    nano \
    gnupg \
    ca-certificates \
    software-properties-common \
    lxde \
    openbox \
    lxterminal \
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
    && add-apt-repository universe \
    && apt update \
    && apt install -y libgtkglext1 libgtk2.0-0 \
    && mkdir -p /var/run/sshd \
    && echo 'root:password' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt update \
    && apt install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# AnyDesk
RUN wget -O /tmp/anydesk.deb https://download.anydesk.com/linux/anydesk_6.3.2-1_amd64.deb \
    && apt install -y /tmp/anydesk.deb \
    && rm /tmp/anydesk.deb

# Playwright + requests
RUN pip3 install --break-system-packages playwright requests \
    && playwright install chrome \
    && playwright install-deps

# User
RUN useradd -m -s /bin/bash user && echo 'user:password' | chpasswd && adduser user sudo

# Working directory + data mount point
WORKDIR /app
RUN mkdir -p /app/data

# Startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22

CMD ["/start.sh"]
