# Base Docker with AnyDesk, SSH, Python, Google Chrome and Playwright

A lightweight base Docker image based on **Ubuntu 24.04** that provides:

- **SSH server** for remote terminal access
- **AnyDesk** for remote desktop access
- Lightweight desktop environment (**Openbox**)
- **Python 3** with pip
- **Google Chrome** (stable)
- **Playwright** + **requests** pre-installed
- Mounted data directory (`/app/data`)

The container starts a virtual display using **Xvfb** (1920x1080), launches Openbox, starts the AnyDesk service with a predefined password, and runs the SSH daemon in the foreground.

## Features

- Ubuntu 24.04 base image
- SSH access (root and regular user)
- AnyDesk remote desktop support
- Google Chrome ready to use
- Playwright + requests installed
- Virtual X11 display via Xvfb
- Python 3 environment
- Openbox window manager
- Shared data directory

## Build and Run

```bash
docker build -t anydesk-base .
docker run -d -p 2222:22 -v ${PWD}/data:/app/data --name anydesk-container anydesk-base
```

### Connect

- **SSH**: `ssh root@localhost -p 2222` or `ssh user@localhost -p 2222`
- **AnyDesk**: Use the AnyDesk client and connect to the container's ID

## Default Credentials

| Service     | Username | Password          |
|-------------|----------|-------------------|
| SSH (root)  | root     | `password`        |
| SSH (user)  | user     | `password`        |
| AnyDesk     | -        | `YourPassword123` |

> **Important:** Change all passwords in the `Dockerfile` and `start.sh` before using this image in any real environment!

## Usage inside container

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(
        headless=False,
        executable_path="/usr/bin/google-chrome-stable",
        args=["--no-sandbox", "--disable-dev-shm-usage"]
    )
    page = browser.new_page()
    page.goto("https://example.com")
    print(page.title())
    browser.close()
```

Files from the host `data` folder are available at `/app/data`.

## Notes

- This is a **base image** intended for further customization.
- AnyDesk ID can be retrieved after startup (`anydesk --get-id`).
- Google Chrome is available as `google-chrome-stable`.
- The image runs as root for simplicity (SSH daemon). Consider hardening for production use.
