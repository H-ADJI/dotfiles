#!/usr/bin/env bash

venv_activate() {
    if [ -d "./.venv" ]; then
        source ".venv/bin/activate"
    fi

}
