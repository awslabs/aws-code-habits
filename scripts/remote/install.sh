#!/usr/bin/env bash

set -e
set -u
set -o pipefail

git submodule add --name habits -b main https://github.com/awslabs/aws-code-habits.git habits
cp habits/scripts/Makefile Makefile
make habits/install
echo "AWS Code Habits installed successfully!"
