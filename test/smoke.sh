#!/bin/sh
# Builds the bare-machine test image and runs the full bootstrap from scratch
# inside it, verifying the onboarding flow end to end.
#
# The repo is volume-mounted and used directly as the chezmoi source
# (DOTFILES_LOCAL_SOURCE), so uncommitted local changes are what get tested.
set -eu
cd "$(dirname "$0")/.."

IMAGE=matt-dotfiles-bootstrap-test

echo "==> building image (debian:latest + fish/git/curl only)"
docker build -q -t "$IMAGE" test/

echo "==> running bootstrap + verification in container"
docker run --rm \
    -e CHEZMOI_MACHINE_TYPE=personal \
    -e DOTFILES_LOCAL_SOURCE=/dotfiles \
    -v "$(pwd):/dotfiles" \
    "$IMAGE" sh /dotfiles/test/inside.sh
