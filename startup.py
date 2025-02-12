#!/usr/bin/env python3

import os
import sys

# Access environment variables
USER = os.environ.get('USER')
HOME = os.environ.get('HOME')
NEW_UID = os.environ.get('NEW_UID', '1000')
NEW_GID = os.environ.get('NEW_GID', '1000')
NEW_PWD = os.environ.get('NEW_PWD', 'changeme')
VNCPORT = os.environ.get('VNCPORT', '5900')
NOVNCPORT = os.environ.get('NOVNCPORT', '9090')
VNCPWD = os.environ.get('VNCPWD', 'changeme')
VNCDISPLAY = os.environ.get('VNCDISPLAY', '1920x1080')
VNCDEPTH = os.environ.get('VNCDEPTH', '16')


def step_1_root():
    print("Change UID and GID of the ubuntu user.")
    os.system(f"sudo usermod -u {NEW_UID} ubuntu")
    os.system(f"sudo groupmod -g {NEW_GID} ubuntu")
    os.system(f"sudo usermod -g {NEW_GID} ubuntu")
    os.system("find / -uid 1000 -exec chown " + NEW_UID + " '{}' \;")
    os.system("find / -gid 1000 -exec chgrp " + NEW_GID + " '{}' \;")
    print("Change password of the ubuntu user")
    os.system(f"echo 'ubuntu:{NEW_PWD}' | sudo chpasswd")


def step_2_user():
    print("Setup VNC server configuration")
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
/usr/share/novnc/utils/novnc_proxy --listen {NOVNCPORT} --vnc localhost:{VNCPORT}
    """.strip())


if "--step-1-root" in sys.argv:
    step_1_root()
elif "--step-2-user" in sys.argv:
    step_2_user()
