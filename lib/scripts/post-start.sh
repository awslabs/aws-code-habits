#!/bin/bash
set -o pipefail

# HABITS:001:Default git branch should always be 'main'
sudo su - vscode -c 'git config init.defaultBranch main'

# HABITS:002:Squash commits on merge
sudo su - vscode -c 'git config branch.main.mergeOptions "--squash"'
