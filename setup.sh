#!/bin/bash

# Determine which command to use for privilege escalation
if command -v sudo > /dev/null 2>&1; then
    sudo_cmd="sudo"
elif command -v doas > /dev/null 2>&1; then
    sudo_cmd="doas"
else
    echo "Neither sudo nor doas found. Please install one of them."
    exit 1
fi

# 'apt' (Debian)
if [[ "$(command -v apt)" != "" ]]; then
    # Perform repositories updates to prevent dead mirrors
    echo "[INFO] Updating repositories..."
    $sudo_cmd apt update > /dev/null 2>&1

    # Install required packages in form of a 'for' loop
    for package in unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract device-tree-compiler liblzma-dev python3-pip brotli liblz4-tool axel gawk aria2 detox cpio rename liblz4-dev curl python3-venv; do
        echo "[INFO] Installing '${package}'..."
        $sudo_cmd apt install  -y "${package}" > /dev/null 2>&1 || \
            echo "[ERROR] Failed installing '${package}'."
    done
# 'dnf' (Fedora)
elif [[ "$(command -v dnf)" != "" ]]; then
    # Install required packages in form of a 'for' loop
    for package in unace unrar zip unzip sharutils uudeview arj cabextract file-roller dtc python3-pip brotli axel aria2 detox cpio lz4 python3-devel xz-devel p7zip p7zip-plugins; do
        echo "[INFO] Installing '${package}'..."
        $sudo_cmd dnf install -y "${package}" > /dev/null 2>&1 || \
            echo "[ERROR] Failed installing '${package}'."
    done
# 'pacman' (Arch Linux)
elif [[ "$(command -v pacman)" != "" ]]; then
    # Install required packages in form of a 'for' loop
    for package in unace unrar zip unzip p7zip sharutils uudeview arj cabextract file-roller dtc python-pip brotli axel gawk aria2 detox cpio lz4; do
        echo "[INFO] Installing '${package}'..."
        $sudo_cmd pacman -Sy --noconfirm --needed "${package}" > /dev/null 2>&1 || \
            echo "[ERROR] Failed installing '${package}'."
    done
fi
PIP=pip3

# Create virtual environment and install packages
python3 -m venv .venv
source .venv/bin/activate
"$PIP" install aospdtgen backports.lzma extract-dtb protobuf pycryptodome docopt zstandard
