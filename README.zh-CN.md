# dotfiles

![macOS](https://img.shields.io/badge/macOS-26.2-blue?style=flat-square&logo=Apple)
![Platform](https://img.shields.io/badge/platform-amd64-blue?style=flat-square&logo=Intel)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

> 个人的 macOS 配置文件与 Homebrew 应用集合

[English](README.md) | [中文](README.zh-CN.md)

---

## 📖 简介

这是一套精心配置的 macOS 开发环境，包含常用的命令行工具、开发工具和应用程序的自动化安装配置。所有包管理器均已配置国内镜像源，确保安装速度。

## ✨ 特性

- 🚀 **一键安装** - 自动化脚本快速配置完整的开发环境
- 🇨🇳 **国内镜像** - Homebrew、npm、pip 等已配置国内镜像加速
- 🛠️ **开发工具** - 集成 Neovim (LazyVim)、Git、Docker、Kubernetes 等开发工具
- 🎨 **终端美化** - Oh My Zsh + Powerlevel10k + iTerm2 配置
- 📦 **常用应用** - Chrome、VS Code、微信、Telegram 等日常应用

## 📦 安装清单

### Homebrew 命令行工具
- **版本控制**: git、git-extras、tig
- **编辑器**: Neovim (LazyVim)
- **终端工具**: tmux、fzf、ripgrep、tree、tokei、watch
- **系统工具**: coreutils、findutils、gnu-tar、gnu-sed、less、unzip
- **开发工具**: make、maven、shellcheck、jq、ctags
- **编程语言**: Go、Python、Rust、Lua、Java (GraalVM)、Node.js (通过 nvm)
- **容器与编排**: Docker、Kubernetes (kubectl、helm、kustomize、kompose、istioctl、kind、kubebuilder)
- **其他工具**: gawk、gibo、grep、iproute2mac、lrzsz、luarocks、mdbook、moreutils、nmap、oath-toolkit、opencode、pipx、sshpass、telnet

### Python 工具 (通过 pipx)
- **开发工具**: s3cmd、ansible、ansible-lint
- **数据库**: mycli、pgcli
- **网络工具**: mitmproxy

### Node.js 工具 (通过 npm)
- bun、gitmoji-cli

### Oh My Zsh 插件
- Powerlevel10k、zsh-autosuggestions、zsh-syntax-highlighting、zsh-completions、you-should-use

### Homebrew 应用程序
- **浏览器**: Google Chrome
- **开发工具**: Visual Studio Code、Docker、Android Platform Tools
- **通讯**: 微信、Telegram、QQ
- **云存储**: 阿里云盘、百度网盘
- **媒体**: IINA、QQ音乐
- **其他**: Clash Verge、iTerm2、VirtualBox、Vagrant、Wireshark
- **字体**: Cascadia Code NF
- **生产力**: Citrix Workspace、腾讯会议、柠檬清理

## 🚀 快速开始

### 前置要求

安装 Xcode 命令行工具：

```bash
xcode-select --install
```

克隆本仓库：

```bash
git clone git@github.com:kuops/dotfiles.git
```

### 代理配置（必须）

在运行安装脚本前必须配置代理，因为某些软件在中国无法直接下载：

```bash
export ALL_PROXY="代理地址:端口"
export NO_PROXY=".cn,.npmmirror.com,localhost,127.0.0.1"
```

### 运行安装脚本

进入项目目录并执行安装脚本：

```bash
cd dotfiles && bash install.sh
```

### 安装脚本功能

- ✅ 安装 Homebrew 并配置国内镜像
- ✅ 安装常用应用程序和命令行工具
- ✅ 配置 Oh My Zsh 并切换默认 Shell 为 Zsh
- ✅ 配置 Neovim 和 LazyVim
- ✅ 配置 pip、npm、git、SSH 等工具
- ✅ 配置 iTerm2 偏好设置

## 📝 使用说明

### Gas Mask 使用

在打开 Gas Mask 前先执行：

```bash
sudo spctl --master-disable
```

### tmux 插件安装

使用 tpm 安装 tmux 插件：

```bash
# 按 Ctrl + a，然后按大写 I
Ctrl + a, I
```

### Microsoft Office 安装

前往 [Microsoft Office](https://www.microsoft.com/microsoft-365/microsoft-office) 官网下载安装。

### JetBrains IDE 安装（可选）

通过 Homebrew Cask 安装（不在自动安装脚本中）：

```bash
brew install --cask intellij-idea  # IntelliJ IDEA
brew install --cask pycharm        # PyCharm
brew install --cask webstorm       # WebStorm
```

## ❓ 常见问题

### Homebrew 安装失败

尝试手动安装：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

### tmux 插件未加载

手动安装插件：

```bash
# 如果 tmux 插件管理器不存在，先安装
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 按下前缀键 Ctrl + a，然后按大写 I 安装插件
```

### Powerlevel10k 提示符不显示

手动配置：

```bash
p10k configure
```

### iTerm2 配置未生效

1. 复制 iTerm2 脚本：

```bash
cp iterm2/iterm2-*.sh /usr/local/bin
chmod +x /usr/local/bin/iterm2-*.sh
```

2. 完整配置需手动导入：在 iTerm2 中打开 `Preferences > General > Preferences`，导入 `iterm2/com.googlecode.iterm2.plist` 文件。


### Shell 未切换为 Zsh

手动切换 Shell：

```bash
chsh -s /bin/zsh
```

退出并重新登录后生效。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件
