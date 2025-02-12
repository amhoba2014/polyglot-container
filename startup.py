#!/usr/bin/env python3

import os
import sys

# Access environment variables
USER = os.environ.get('USER')
HOME = os.environ.get('HOME')
VNCPORT = os.environ.get('VNCPORT', 5900)
NOVNCPORT = os.environ.get('NOVNCPORT', 9090)
VNCPWD = os.environ.get('VNCPWD', 'changeme')
VNCDISPLAY = os.environ.get('VNCDISPLAY', '1920x1080')
VNCDEPTH = os.environ.get('VNCDEPTH', 16)


def step_1_root():
    # Setup noVNC with SSL certificates
    os.system("""
openssl req -new -x509 -days 365 -nodes \
-subj "/C=US/ST=IL/L=Springfield/O=OpenSource/CN=localhost" \
-out /etc/ssl/certs/novnc_cert.pem -keyout /etc/ssl/private/novnc_key.pem && \
cat /etc/ssl/certs/novnc_cert.pem /etc/ssl/private/novnc_key.pem > /etc/ssl/private/novnc_combined.pem && \
chmod 600 /etc/ssl/private/novnc_combined.pem
    """.strip())


def step_2_user():
    # Setup VNC server configuration
    os.system(f"mkdir -p {HOME}/.vnc/")
    os.system(f"echo {VNCPWD} | vncpasswd -f > {HOME}/.vnc/passwd")
    os.system(f"chmod 600 {HOME}/.vnc/passwd")
    with open(f"{HOME}/.vnc/xstartup", "w") as fp:
        fp.write("""
#!/bin/sh
xrdb $HOME/.Xresources
xsetroot -solid grey
export XKL_XMODMAP_DISABLE=1
/etc/X11/Xsession
startxfce4 &
        """.strip())
    os.system(f"chmod +x {HOME}/.vnc/xstartup")

    os.system(f"""
echo 'NoVNC Certificate Fingerprint:';
openssl x509 -in /etc/ssl/certs/novnc_cert.pem -noout -fingerprint -sha256;
vncserver :0 -rfbport {VNCPORT} -geometry {VNCDISPLAY} -depth {VNCDEPTH} -localhost;
/usr/share/novnc/utils/launch.sh --listen {NOVNCPORT} --vnc localhost:{VNCPORT} --cert /etc/ssl/private/novnc_combined.pem
    """.strip())


if "--step-1-root" in sys.argv:
    step_1_root()
elif "--step-2-user" in sys.argv:
    step_2_user()
