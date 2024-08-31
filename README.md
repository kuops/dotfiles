# dotfiles

![Static Badge](https://img.shields.io/badge/macOS-14.6.1-blue?style=flat-square&logo=Apple)
![Static Badge](https://img.shields.io/badge/processors-Intel-blue?style=flat-square)

My macOS dotfiles and homebrew applications.

> :cn: all package manager toools configured china mirror.

## Installation

### Prerequisites

Install xcode command line tools:

```bash
xcode-select --install
```

Clone this repository using Git:

```bash
git clone git@github.com:kuops/dotfiles.git
```

### Configure Proxy

If necessary, set up command line proxy:

```bash
export ALL_PROXY="proxy_ip:port"
export NO_PROXY=".cn,.npmmirror.com,localhost,127.0.0.1"
```

### Run the Installation Script

Navigate into the repository directory and run the installation script:

```bash
cd dotfiles && bash install.sh
```

### Script Functionality

- Installs Homebrew.
- Configures Homebrew to use China mirrors.
- Installs popular applications and command-line tools.
- Sets up Oh My Zsh and switches the shell to Zsh.
- Configures Neovim and sets up LazyVim.
- Configures preferences for pip, npm, pnpm, git, and SSH.
- Sets up Iterm2 preferences.

## Additional Information

### Using Gas Mask

To use Gas Mask, execute the following command before opening the application:

```bash
sudo spctl --master-disable
```

### tmux Plugin Installation

Install tmux plugins using tpm:

```bash
prefix(ctrl + a) + I
```

### Install Microsoft Office For macOS

Fllow the [Microsoft-Office-For-MacOS](https://github.com/alsyundawy/Microsoft-Office-For-MacOS) tutorial install it.
