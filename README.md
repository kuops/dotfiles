# dotfiles

![macOS](https://img.shields.io/badge/macOS-26.2-blue?style=flat-square&logo=Apple)
![Platform](https://img.shields.io/badge/platform-amd64-blue?style=flat-square&logo=Intel)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

> Personal macOS configuration files and Homebrew applications

[English](README.md) | [中文](README.zh-CN.md)

---

## 📖 Introduction

A fully automated macOS development environment setup with popular command-line tools, development tools, and applications. All package managers are configured with China mirror sources for faster installation.

## ✨ Features

- 🚀 **One-click installation** - Automated script to quickly set up a complete development environment
- 🇨🇳 **China mirrors** - Homebrew, npm, pip, and other package managers configured with China mirrors
- 🛠️ **Development tools** - Neovim (LazyVim), Git, Docker, Kubernetes, and more
- 🎨 **Terminal beautification** - Oh My Zsh + Powerlevel10k + iTerm2 configuration
- 📦 **Daily apps** - Chrome, VS Code, WeChat, Telegram, and other common applications

## 📦 Installation List

### Homebrew Command-line Tools
- **Version Control**: git, git-extras, tig
- **Editor**: Neovim (LazyVim)
- **Terminal Tools**: tmux, fzf, ripgrep, tree, tokei, watch
- **System Tools**: coreutils, findutils, gnu-tar, gnu-sed, less, unzip
- **Development Tools**: make, maven, shellcheck, jq, ctags
- **Programming Languages**: Go, Python, Rust, Lua, Java (GraalVM), Node.js (via nvm)
- **Containers & Orchestration**: Docker, Kubernetes (kubectl, helm, kustomize, kompose, istioctl, kind, kubebuilder)
- **Other Tools**: gawk, gibo, grep, iproute2mac, lrzsz, luarocks, mdbook, moreutils, nmap, oath-toolkit, opencode, pipx, sshpass, telnet

### Python Tools (via pipx)
- **Development Tools**: s3cmd, ansible, ansible-lint
- **Databases**: mycli, pgcli
- **Network Tools**: mitmproxy

### Node.js Tools (via npm)
- bun, gitmoji-cli

### Oh My Zsh Plugins
- Powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, you-should-use

### Homebrew Applications
- **Browser**: Google Chrome
- **Development Tools**: Visual Studio Code, Docker, Android Platform Tools
- **Communication**: WeChat, Telegram, QQ
- **Cloud Storage**: Aliyun Drive, Baidu Netdisk
- **Media Players**: IINA, QQ Music
- **Others**: Clash Verge, iTerm2, VirtualBox, Vagrant, Wireshark
- **Fonts**: Cascadia Code NF
- **Productivity**: Citrix Workspace, Tencent Meeting, Tencent Lemon

## 🚀 Quick Start

### Prerequisites

Install Xcode command line tools:

```bash
xcode-select --install
```

Clone this repository:

```bash
git clone git@github.com:kuops/dotfiles.git
```

### Proxy Configuration (Required)

You must configure a proxy before running the installation script, as some software cannot be downloaded in China without a proxy:

```bash
export ALL_PROXY="proxy_ip:port"
export NO_PROXY=".cn,.npmmirror.com,localhost,127.0.0.1"
```

### Run Installation Script

Navigate to the repository directory and run the installation script:

```bash
cd dotfiles && bash install.sh
```

### Script Functionality

- ✅ Install Homebrew and configure China mirrors
- ✅ Install popular applications and command-line tools
- ✅ Set up Oh My Zsh and switch default shell to Zsh
- ✅ Configure Neovim and LazyVim
- ✅ Configure pip, npm, git, SSH, and other tools
- ✅ Set up iTerm2 preferences

## 📝 Usage

### Using Gas Mask

Execute the following command before opening Gas Mask:

```bash
sudo spctl --master-disable
```

### tmux Plugin Installation

Install tmux plugins using tpm:

```bash
# Press Ctrl + a, then press capital I
Ctrl + a, I
```

### Microsoft Office Installation

Visit [Microsoft Office](https://www.microsoft.com/microsoft-365/microsoft-office) official website to download and install.

### JetBrains IDE Installation (Optional)

Install via Homebrew Cask (not included in automated script):

```bash
brew install --cask intellij-idea  # IntelliJ IDEA
brew install --cask pycharm        # PyCharm
brew install --cask webstorm       # WebStorm
```

## ❓ Troubleshooting

### Homebrew installation fails

Try installing manually:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

### tmux plugins not loading

Install plugins manually:

```bash
# Install tmux plugin manager if not present
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Press prefix + I (Ctrl-a then I) to install plugins
```

### Powerlevel10k prompt not working

Configure it manually:

```bash
p10k configure
```

### iTerm2 preferences not applied

1. Copy iTerm2 scripts:

```bash
cp iterm2/iterm2-*.sh /usr/local/bin
chmod +x /usr/local/bin/iterm2-*.sh
```

2. For full preferences, manually import `iterm2/com.googlecode.iterm2.plist` through iTerm2 settings (Preferences > General > Preferences)

### Shell not changed to Zsh

Change shell manually:

```bash
chsh -s /bin/zsh
```

Log out and log back in for changes to take effect.

## 🤝 Contributing

Issues and Pull Requests are welcome!

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
