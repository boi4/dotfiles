#!/usr/bin/env python3
import json
import os.path
import subprocess

def rofi(l):
    r = subprocess.Popen(["rofi", "-i", "-dmenu", "-matching", "fuzzy"], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    r.stdin.write("\n".join(l).encode('utf-8'))
    r.stdin.close()
    return r.stdout.read().decode('utf-8')[:-1]

a = json.load(open(os.path.expanduser("~/.config/obsidian/obsidian.json")))
vaults = [vault['path'].split("/")[-1] for vault in a["vaults"].values()]
choice = rofi(vaults)
if choice.strip():
    args = ['obsidian', f'obsidian://open?vault={choice}']
    subprocess.run(args)

