# Minimal "bare machine" test image for the bootstrap process.
# Installs ONLY the documented prerequisites (fish, git + curl for downloads);
# mise, chezmoi, and all tools must come from bootstrap.sh.
#
# Build & run: ./test/smoke.sh
FROM debian:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        fish \
        git \
        libatomic1 \
        unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root
