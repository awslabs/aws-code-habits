#!/usr/bin/env bash

set -e
set -u
set -o pipefail

git clone --branch=main --depth=1 https://github.com/awslabs/aws-code-habits.git habits
rm -rf habits/.git
cp habits/scripts/Makefile Makefile
make habits/install habits/init
echo 'habits/' >> .gitignore
echo "AWS Code Habits installed successfully!"
