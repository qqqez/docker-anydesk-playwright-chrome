# Base Docker with AnyDesk, SSH, Python and Chromium

A lightweight base Docker image based on **Ubuntu 24.04** that provides:

- **SSH server** for remote terminal access
- **AnyDesk** for remote desktop access
- Lightweight desktop environment (**Openbox**)
- **Python 3** with pip
- **Chromium** browser (pre-installed)

The container starts a virtual display using **Xvfb** (1920x1080), launches Openbox, starts the AnyDesk service with a predefined password, and runs the SSH daemon in the foreground.

## Features

- Ubuntu 24.04 base image
- SSH access (root and regular user)
- AnyDesk remote desktop support
- Chromium browser ready to use
- Virtual X11 display via Xvfb
- Python 3 environment ready for customization
- Openbox window manager

## Build and Run

```bash
docker build -t anydesk-base .
docker run -d -p 22:22 --name anydesk-container anydesk-base
```

### Connect

- **SSH**: `ssh root@localhost` or `ssh user@localhost` (map port if needed)
- **AnyDesk**: Use the AnyDesk client and connect to the container's ID (check logs or set up networking accordingly)

## Default Credentials

| Service     | Username | Password          |
|-------------|----------|-------------------|
| SSH (root)  | root     | `password`        |
| SSH (user)  | user     | `password`        |
| AnyDesk     | -        | `YourPassword123` |

> **Important:** Change all passwords in the `Dockerfile` and `start.sh` before using this image in any real environment!

## Customization

- Install additional system packages in the `Dockerfile`
- Modify `start.sh` to change startup behavior or AnyDesk password

## Notes

- This is a **base image** intended for further customization.
- AnyDesk ID can be retrieved after startup (e.g. via `anydesk --get-id`).
- Chromium is available as `chromium-browser`.
- The image runs as root for simplicity (SSH daemon). Consider hardening for production use.
