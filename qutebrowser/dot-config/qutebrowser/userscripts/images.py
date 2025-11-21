#!/usr/bin/python
import os

url = os.environ["QUTE_URL"]
print("something weird")
os.system(f"notify-send 'ahd {url}'")
