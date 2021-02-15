#!/bin/bash

# Symlink .zshrc replacing any symlink or file already there
ln -sf $(pwd)/.zshrc $HOME/.zshrc
ln -sf $(pwd)/.p10k.zsh $HOME/.p10k.zsh

# Install or update Homebrew
which brew &>/dev/null
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $HOME/.zprofile
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
else
    brew update
fi

# Install all items in the Brewfile
if [[ -f "Brewfile" ]]; then
    brew bundle
fi

# Make sure zsh is listed in /etc/shells
grep -q zsh /etc/shells
if [[ $? != 0 ]] ; then
    echo Adding $(which zsh) to /etc/shells
    command -v zsh | sudo tee -a /etc/shells
fi

if [[ $(grep ^$(id -un): /etc/passwd | cut -d : -f 7-) != $(which zsh) ]] ; then
    echo Enter your password to change default shell to $(which zsh)
    chsh -s $(which zsh)
fi

# Install or update zinit
grep -q zinit $HOME/.zshrc
if [[ $? != 0 ]] ; then
    # Install zinit
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

    echo Reload the shell and run ./bootstrap again to finish bootstrap
fi

# Install or update NVM
which nvm &>/dev/null
if [[ $? != 0 ]] ; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | zsh
fi