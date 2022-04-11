#!/bin/bash

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

echo "OS Detected $OS"
echo "OS Version Detected $VER"

# perform apt update if Ubuntu
if [[ $OS == "Ubuntu" ]]; then
    echo "Running 'sudo apt update'"
    sudo apt update
fi

# Basic git setup
git config --global user.name "Dean Raspa"
git config --global user.email "draspa@gmail.com"

# Symlink .zshrc replacing any symlink or file already there
ln -sf $(pwd)/.zshrc $HOME/.zshrc
ln -sf $(pwd)/.p10k.zsh $HOME/.p10k.zsh
ln -sf $(pwd)/.kubectl_aliases $HOME/.kubectl_aliases

# Install or update Homebrew
which brew &>/dev/nulld
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $HOME/.zprofile
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
else
    echo "Running 'brew update'"
    brew update
fi

# Install all items in the Brewfile
if [[ -f "Brewfile" ]]; then
    echo "Brewfile found.  Running 'brew bundle'"
    brew bundle
fi

# Make sure zsh is listed in /etc/shells
grep -q zsh /etc/shells
if [[ $? != 0 ]] ; then
    echo Adding $(which zsh) to /etc/shells
    command -v zsh | sudo tee -a /etc/shells
else
    echo "ZSH found in /etc/shells"
fi

if [[ $(grep ^$(id -un): /etc/passwd | cut -d : -f 7-) != $(which zsh) ]] ; then
    echo "Enter your password to change default shell to $(which zsh)"
    chsh -s $(which zsh)
else
    echo "Your default shell is already $(which zsh)"
fi

# Install zim
if [[ ! -d "$HOME/.zim" ]] ; then 
    echo 'Installing zim'
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
    ln -sf $(pwd)/.zimrc $HOME/.zimrc
else
    echo "ZIM already installed run 'zimfw install' to update your modules"
fi

# Install or update NVM
if [[ ! -d "$HOME/.nvm" ]] ; then 
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | zsh
else
    echo "NVM already installed"
fi

# Install GO 1.17.2 if not present
if [[ ! -d "/usr/local/go" ]] ; then 
    GOVERSION=go1.17.2
    [[ $OS = "Linux" ]] && GOVERSION=$GOVERSION.linux
    [[ $OS = "darwin" ]] && GOVERSION=$GOVERSION.darwin
    [[ $ARCH = "x86_64" ]] && GOVERSION=$GOVERSION-amd64
    [[ $ARCH = "ARM64" ]] && GOVERSION=$GOVERSION-arm64
    GOVERSION=$GOVERSION.tar.gz
    echo "golang version identified as $GOVERSION"

    wget -c https://storage.googleapis.com/golang/$GOVERSION
    sudo tar -C /usr/local -xvf $GOVERSION
    rm -f $GOVERSION
else
    echo "GO 1.17.2 already installed"
fi

# Ensure Go folders are present
if [[ ! -d "$HOME/golibs/bin" ]];  then
    #the libraries are stored within this directory
    mkdir -p ~/golibs/{bin,src,pkg}
    #the projects are stored within this directory
    mkdir -p ~/goprojects/{bin,src,pkg}
fi