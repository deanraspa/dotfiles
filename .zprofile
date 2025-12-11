export PATH="${HOME}/.local/bin:$PATH"

test -e "/opt/homebrew/bin/brew" && eval "$(/opt/homebrew/bin/brew shellenv)"
test -e "/home/linuxbrew/.linuxbrew/bin/brew" && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

## Uncomment if using Yubikey
## Ensure that GPG is correctly confifgured
#export GPG_TTY=$(tty)
#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#gpgconf --launch gpg-agent
#gpg-connect-agent updatestartuptty /bye > /dev/null
