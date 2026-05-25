#!/usr/bin/env bash
# textlint runner for /check-ja skill
# - Uses Node 18+ via nvm if available (textlint v15 requires it)
# - Bypasses user .npmrc that may reference env vars not set in this shell
# - Forwards all arguments to textlint
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Activate nvm Node 18+ if current node is too old
if command -v node >/dev/null 2>&1; then
  NODE_MAJOR=$(node -p "process.versions.node.split('.')[0]" 2>/dev/null || echo "0")
  if [ "$NODE_MAJOR" -lt 18 ]; then
    if [ -s "$HOME/.nvm/nvm.sh" ]; then
      # shellcheck disable=SC1091
      . "$HOME/.nvm/nvm.sh"
      # Pick the newest installed Node >=18
      LATEST=$(ls "$HOME/.nvm/versions/node" 2>/dev/null | sort -V | awk -F. '$1 ~ /^v([0-9]+)/ { v=$1; sub("v","",v); if (v+0 >= 18) print }' | tail -1)
      if [ -n "$LATEST" ]; then
        nvm use "$LATEST" >/dev/null
      fi
    fi
  fi
fi

# Install on first run
if [ ! -d node_modules ]; then
  echo "[check-ja] First run: installing textlint dependencies..." >&2
  npm install --userconfig /dev/null --silent
fi

exec ./node_modules/.bin/textlint "$@"
