#!/usr/bin/env bash
set -euo pipefail

PATH="$PATH:/run/current-system/sw/bin"

function log {
    local timestamp
    timestamp="$(date +"%Y-%m-%dT%H:%M:%S")"
    printf '[%s] %s\n' "${timestamp}" "${1}"
}


log 'nix cleanup job starting!'

# home-manager generations aren't deleted unless you collect garbage as the user.
log 'collecting nix garbage as user...'
sudo --user opeik nix-collect-garbage --delete-old

log 'collecting nix garbage...'
sudo nix-collect-garbage --delete-old

log 'optimizing nix store...'
sudo nix-store --optimise

log 'nix cleanup job done!'
