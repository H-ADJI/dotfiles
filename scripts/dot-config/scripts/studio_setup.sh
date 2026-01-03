#!/usr/bin/env bash

sudo usermod -aG realtime,audio "$USER"
groups "$USER"
