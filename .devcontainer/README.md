## Troubleshooting

### Using SSH-Agent on Windows 10 WSL2

On WSL, Ubuntu:

```bash
sudo apt-get install keychain
```

Edit your `~/.bashrc`, `~/.zshrc` and add the following to the bottom of your file:

```bash
# For Loading the SSH key
/usr/bin/keychain -q --nogui "${HOME}/.ssh/id_rsa"
source "${HOME}/.keychain/${HOSTNAME}-sh"
```

- [Source](https://esc.sh/blog/ssh-agent-windows10-wsl2/)
