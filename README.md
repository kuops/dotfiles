# dotfiles

![macOS](https://img.shields.io/badge/macOS-26.2-blue?style=flat-square&logo=Apple)
![Platform](https://img.shields.io/badge/platform-amd64-blue?style=flat-square&logo=Intel)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

> Personal macOS configuration files and Homebrew applications

[English](README.md) | [中文](README.zh-CN.md)

---

## 📖 Introduction

A fully automated macOS development environment setup with popular command-line tools, development tools, and applications. All package managers are configured with China mirror sources for faster installation.

## ✨ Key Features

- 🚀 **One-click Setup** - Automated script for quick and complete development environment configuration
- 🇨🇳 **China Optimized** - All package managers (Homebrew, npm, pip, etc.) configured with China mirrors
- 🛠️ **Rich Toolset** - Pre-configured development tools including Neovim (LazyVim), Git, Docker, Kubernetes
- 🎨 **Beautiful Terminal** - Oh My Zsh + Powerlevel10k + iTerm2 with custom configurations
- 📦 **Essential Apps** - Curated collection of daily-use applications including Chrome, VS Code, WeChat, Telegram

## 📦 Installation List

### Homebrew Command-line Tools
- **Version Control**: git, git-extras, tig
- **Editor**: Neovim (LazyVim)
- **Terminal Tools**: tmux, fzf, ripgrep, tree, tokei, watch
- **System Tools**: coreutils, diffutils, findutils, gnu-getopt, gnu-tar, gnu-sed, less, unzip
- **Development Tools**: make, maven, shellcheck, jq, ctags, hugo
- **Programming Languages**: Go, Python, Rust, Lua, Node.js (via nvm)
- **Java Runtime**: GraalVM JDK
- **Containers & Orchestration**: Docker, Kubernetes (kubectl, helm, kustomize, kompose, istioctl, kind, kubebuilder)
- **Other Tools**: gawk, gibo, grep, iproute2mac, lrzsz, luarocks, mdbook, moreutils, nmap, oath-toolkit, opencode, pipx, sshpass, telnet

### Python Tools (via pipx)
- **Development Tools**: s3cmd, ansible, ansible-lint
- **Databases**: mycli, pgcli
- **Network Tools**: mitmproxy

### Node.js Tools (via npm)
- bun, gitmoji-cli, @z_ai/coding-helper, agent-browser

### OpenCode Skills
Automatically installs 20 popular OpenCode Skills, including:
- **Frontend Development**: frontend-design, vercel-react-best-practices, tailwind-design-system, vitest, web-design-guidelines
- **Testing**: test-driven-development, webapp-testing
- **Golang**: golang-pro, golang-patterns, golang-testing
- **UI/UX**: ui-ux-pro-max
- **Document Processing**: pptx, docx, xlsx (PowerPoint, Word, Excel)
- **Development Tools**: agent-browser, api-design-principles, brainstorming, find-skills, skill-creator, planning-with-files

### Oh My Zsh Plugins
- Powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, you-should-use

### Homebrew Applications
- **Browser**: Google Chrome
- **Development Tools**: Visual Studio Code, Docker, Android Platform Tools, GraalVM JDK
- **Communication**: WeChat, Telegram, QQ, Feishu
- **Cloud Storage**: Aliyun Drive, Baidu Netdisk
- **Media Players**: IINA, QQ Music
- **Network Tools**: Clash Verge Rev, Wireshark
- **Virtualization**: VirtualBox, Vagrant
- **Terminal**: iTerm2
- **Fonts**: Cascadia Code NF
- **Productivity**: Citrix Workspace, Tencent Meeting, Tencent Lemon, Obsidian

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

### Proxy Configuration (Required for China)

**Important**: You must configure a proxy before running the installation script, as some software cannot be downloaded directly in China.

Set the following environment variables:

```bash
export ALL_PROXY="proxy_ip:port"
export NO_PROXY=".cn,.npmmirror.com,localhost,127.0.0.1"
```

### Run Installation Script

Navigate to the repository directory and run the installation script:

```bash
cd dotfiles && bash install.sh
```

### What the Script Does

The installation script automates the following tasks:

- ✅ Installs Homebrew and configures China mirrors for faster downloads
- ✅ Installs popular command-line tools and applications
- ✅ Sets up Oh My Zsh with Powerlevel10k theme and switches default shell to Zsh
- ✅ Installs and configures Neovim with LazyVim configuration
- ✅ Automatically installs 20 popular OpenCode Skills
- ✅ Configures pip, npm, git, SSH, and other development tools
- ✅ Sets up iTerm2 preferences and scripts

## 📝 Post-Installation Usage

### tmux Plugin Installation

Install tmux plugins using tpm:

```bash
# Start a new tmux session
tmux
```

Then press `Ctrl + a` followed by `Shift + I` (capital I) to install plugins.

### Microsoft Office Installation

Install Microsoft Office via Homebrew Cask:

```bash
brew install --cask microsoft-word microsoft-excel microsoft-powerpoint
```

> 💡 **Tip**: If Homebrew installation fails, you can refer to [Microsoft-Office-For-MacOS](https://github.com/alsyundawy/Microsoft-Office-For-MacOS) for alternative installation methods.

### JetBrains IDE Installation (Optional)

The installation script does not include JetBrains IDEs. You can install them via Homebrew Cask if needed:

```bash
brew install --cask intellij-idea  # IntelliJ IDEA
brew install --cask pycharm        # PyCharm
brew install --cask webstorm       # WebStorm
```

## ❓ Troubleshooting

### Homebrew Installation Fails

If the automatic installation fails, try installing Homebrew manually:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

### tmux Plugins Not Loading

If tmux plugins are not working, install them manually:

```bash
# Install tmux plugin manager if not present
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Press prefix + I (Ctrl-a then I) to install plugins
```

### Powerlevel10k Prompt Not Working

If the Powerlevel10k theme is not displaying correctly, run the configuration wizard:

```bash
p10k configure
```

### iTerm2 Preferences Not Applied

To apply iTerm2 configurations:

1. First, copy the iTerm2 scripts:

```bash
cp iterm2/iterm2-*.sh /usr/local/bin
chmod +x /usr/local/bin/iterm2-*.sh
```

2. For complete preferences, manually import `iterm2/com.googlecode.iterm2.plist` through iTerm2 settings (Preferences > General > Preferences)

### Default Shell Not Changed to Zsh

If the shell was not automatically changed to Zsh, do it manually:

```bash
chsh -s /bin/zsh
```

You'll need to log out and log back in for the changes to take effect.

## 🤝 Contributing

Issues and Pull Requests are welcome!

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
