#!/usr/bin/env bash
# Clone repos enlisted in common/tmux/sessions/*.yaml into their start_directory.
# A session yaml opts in with:  repo: user/repo.git
# Skips any project dir that already exists. Requires yq.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SESSIONS="$SCRIPT_DIR/../tmux/sessions"

for f in "$SESSIONS"/*.yaml; do
  repo="$(yq '.repo // ""' "$f")"
  [[ -z "$repo" || "$repo" == "null" ]] && continue
  dir="$(yq '.start_directory // ""' "$f")"
  dir="${dir/#\~/$HOME}"
  if [[ -d "$dir" ]]; then
    echo "skip: $dir (already exists)"
  else
    mkdir -p "$(dirname "$dir")"
    git clone "git@github.com:$repo" "$dir"
  fi
done