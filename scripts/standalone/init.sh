#!/usr/bin/env bash

set -e
set -u
set -o pipefail

git clone --branch=main --depth=1 https://github.com/awslabs/aws-code-habits.git habits
rm -rf habits/.git

echo 'export WORKSPACE=$(shell pwd)' | tee Makefile
echo 'export HABITS = $(WORKSPACE)/habits' | tee --append Makefile
echo 'include $(HABITS)/lib/make/Makefile' | tee --append Makefile
echo 'include $(HABITS)/lib/make/*/Makefile' | tee --append Makefile
make habits/install
make habits/init
echo 'habits/' >> .gitignore
echo "AWS Code Habits installed successfully!"
