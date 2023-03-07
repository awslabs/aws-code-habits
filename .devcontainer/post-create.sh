#!/usr/bin/env bash

set -euxo pipefail

export WORKSPACE=$(pwd)
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get -y install --no-install-recommends \
	bash-completion \
    make

pip3 install --user -r "${WORKSPACE}/.devcontainer/requirements.txt"

clear

devcontainer-info
