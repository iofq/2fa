# 2fa
a 'pass'-esque script for OAuth secrets and 2FA code generation, using gpg and oathtool.

## Dependancies
2fa relies on gpg2 and [oathtool](https://www.nongnu.org/oath-toolkit/index.html). xclip or wl-clipboard is optional for copy-to-clipboard functionality.

## Installation
```
git clone https://github.com/iofq/2fa
cd 2fa && sudo make install
```
to uninstall, `sudo make uninstall`

## Usage
2fa uses your PGP key to encrypt OAuth secrets and store them locally in `~/.2fa`. When generating codes, the reverse happens: the file is decrypted, piped into oathtool, and the resulting code copied to the clipboard (via xclip or wl-clipboard, if installed). Backing up `~/.2fa` is highly recommended!

#### Commands
`2fa -r email add <service> <secret_key>` - Encrypts sercret key in `~/.2fa/<service>.key.gpg`

`2fa -r email gen <service>` -  Decrypts `~/.2fa/<service>.key.gpg` and generates a one-time TOTP code from the secret. The TOTP code is copied to the clipboard via `xclip` or `wl-clipboard`, if installed.

`2fa ls` - Lists all services/secrets in `~/.2fa`

#### Options
`-r gpg@example.com` - 2fa uses your PGP/GPG key to encrypt files and needs to know which key to use. You can instead automate this by setting the env var `$GPG_2FA` to "gpg@example.com"

