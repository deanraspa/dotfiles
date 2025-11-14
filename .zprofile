
eval "$(/opt/homebrew/bin/brew shellenv)"

# Ensure that GPG is correctly confifgured
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Created by `pipx` on 2024-01-25 21:22:56
export PATH="$PATH:/Users/draspa/.local/bin"
