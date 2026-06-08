#!/usr/bin/env python3
"""Minimal Panecho/cmux JSON-RPC client. Usage: python3 recipe.py"""
import json, os, socket


def socket_path():
    # Panecho injects CMUX_SOCKET_PATH into every surface. Outside a surface,
    # fall back to the live path the app records, then the XDG default.
    p = os.environ.get("CMUX_SOCKET_PATH")
    if p:
        return p
    last = os.path.expanduser("~/.local/state/cmux/last-socket-path")
    try:
        with open(last) as f:
            return f.read().strip()
    except OSError:
        return os.path.expanduser("~/.local/state/cmux/cmux.sock")


SOCK = socket_path()


def rpc(method, params=None, req_id="1"):
    payload = {"id": req_id, "method": method, "params": params or {}}
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
        s.connect(SOCK)
        s.sendall(json.dumps(payload).encode() + b"\n")
        return json.loads(s.recv(65536).decode())


if __name__ == "__main__":
    print("ping:", rpc("system.ping"))
    print("workspaces:", rpc("workspace.list"))
    print("notify:", rpc("notification.create", {"title": "Hi", "body": "From Python"}))
