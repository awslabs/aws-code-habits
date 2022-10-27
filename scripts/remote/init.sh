#!/usr/bin/env bash

set -e
set -u
set -o pipefail

git submodule add --name habits -b main https://github.com/awslabs/aws-code-habits.git habits
echo 'export WORKSPACE=$(shell pwd)' | tee Makefile
echo 'export HABITS = $(WORKSPACE)/habits' | tee --append Makefile
echo 'include $(HABITS)/lib/make/Makefile' | tee --append Makefile
echo 'include $(HABITS)/lib/make/*/Makefile' | tee --append Makefile
make habits/install
make habits/init
echo "AWS Code Habits installed successfully!"
