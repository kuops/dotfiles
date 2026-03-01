# dotfiles

![macOS](https://img.shields.io/badge/macOS-26.2-blue?style=flat-square&logo=Apple)
![Platform](https://img.shields.io/badge/platform-amd64-blue?style=flat-square&logo=Intel)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

> 个人的 macOS 配置文件与 Homebrew 应用集合

[English](README.md) | [中文](README.zh-CN.md)

---

## 📖 简介

这是一套精心配置的 macOS 开发环境，包含常用的命令行工具、开发工具和应用程序的自动化安装配置。所有包管理器均已配置国内镜像源，确保安装速度。

## ✨ 主要特性

- 🚀 **一键配置** - 自动化脚本快速完成完整的开发环境配置
- 🇨🇳 **国内优化** - 所有包管理器（Homebrew、npm、pip 等）均已配置国内镜像加速
- 🛠️ **丰富工具集** - 预配置 Neovim (LazyVim)、Git、Docker、Kubernetes 等开发工具
- 🎨 **美化终端** - Oh My Zsh + Powerlevel10k + iTerm2 自定义配置
- 📦 **精选应用** - 精心挑选的常用应用，包括 Chrome、VS Code、微信、Telegram 等

## 📦 安装清单

### Homebrew 命令行工具
- **版本控制**: git、git-extras、tig
- **编辑器**: Neovim (LazyVim)
- **终端工具**: tmux、fzf、ripgrep、tree、tokei、watch
- **系统工具**: coreutils、diffutils、findutils、gnu-getopt、gnu-tar、gnu-sed、less、unzip
- **开发工具**: make、maven、shellcheck、jq、ctags、hugo
- **编程语言**: Go、Python、Rust、Lua、Node.js (通过 nvm)
- **Java 运行时**: GraalVM JDK
- **容器与编排**: Docker、Kubernetes (kubectl、helm、kustomize、kompose、istioctl、kind、kubebuilder)
- **其他工具**: gawk、gibo、grep、iproute2mac、lrzsz、luarocks、mdbook、moreutils、nmap、oath-toolkit、opencode、pipx、sshpass、telnet

### Python 工具 (通过 pipx)
- **开发工具**: s3cmd、ansible、ansible-lint
- **数据库**: mycli、pgcli
- **网络工具**: mitmproxy

### Node.js 工具 (通过 npm)
- bun、gitmoji-cli、@z_ai/coding-helper、agent-browser

### OpenCode Skills
自动安装 20 个常用的 OpenCode Skills，包括：
- **前端开发**: frontend-design、vercel-react-best-practices、tailwind-design-system、vitest、web-design-guidelines
- **测试**: test-driven-development、webapp-testing
- **Golang**: golang-pro、golang-patterns、golang-testing
- **UI/UX**: ui-ux-pro-max
- **文档处理**: pptx、docx、xlsx（PowerPoint、Word、Excel）
- **开发工具**: agent-browser、api-design-principles、brainstorming、find-skills、skill-creator、planning-with-files

### Oh My Zsh 插件
- Powerlevel10k、zsh-autosuggestions、zsh-syntax-highlighting、zsh-completions、you-should-use

### Homebrew 应用程序
- **浏览器**: Google Chrome
- **开发工具**: Visual Studio Code、Docker、Android Platform Tools、GraalVM JDK
- **通讯**: 微信、Telegram、QQ、飞书
- **云存储**: 阿里云盘、百度网盘
- **媒体**: IINA、QQ音乐
- **网络工具**: Clash Verge Rev、Wireshark
- **虚拟化**: VirtualBox、Vagrant
- **终端**: iTerm2
- **字体**: Cascadia Code NF
- **生产力**: Citrix Workspace、腾讯会议、柠檬清理、Obsidian

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

### 代理配置（国内必须）

**重要提示**：在国内环境下，运行安装脚本前必须配置代理，因为某些软件无法直接下载。

请设置以下环境变量：

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

安装脚本会自动完成以下任务：

- ✅ 安装 Homebrew 并配置国内镜像以加速下载
- ✅ 安装常用命令行工具和应用程序
- ✅ 安装 Oh My Zsh 和 Powerlevel10k 主题，并切换默认 Shell 为 Zsh
- ✅ 安装并配置 Neovim 和 LazyVim
- ✅ 自动安装 20 个常用的 OpenCode Skills
- ✅ 配置 pip、npm、git、SSH 等开发工具
- ✅ 配置 iTerm2 偏好设置和脚本

## 📝 安装后使用说明

### tmux 插件安装

使用 tpm 安装 tmux 插件：

```bash
# 启动一个新的 tmux 会话
tmux
```

然后按 `Ctrl + a`，再按 `Shift + I`（大写 I）来安装插件。

### Microsoft Office

参考 [Microsoft-Office-For-MacOS](https://github.com/alsyundawy/Microsoft-Office-For-MacOS)

## ❓ 常见问题

### Homebrew 安装失败

如果自动安装失败，请尝试手动安装 Homebrew：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

### tmux 插件未加载

如果 tmux 插件未正常工作，请手动安装：

```bash
# 如果 tmux 插件管理器不存在，先安装
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 按下前缀键 Ctrl + a，然后按大写 I 安装插件
```

### Powerlevel10k 提示符不显示

如果 Powerlevel10k 主题未正确显示，请运行配置向导：

```bash
p10k configure
```

### iTerm2 配置未生效

要应用 iTerm2 配置，复制 iTerm2 脚本：

```bash
cp iterm2/iterm2-*.sh /usr/local/bin
chmod +x /usr/local/bin/iterm2-*.sh
```

如需备份和还原 iTerm2 偏好设置：

```bash
# 备份现有 iTerm2 配置
plutil -convert xml1 ~/Library/Preferences/com.googlecode.iterm2.plist -o iterm2/com.googlecode.iterm2.plist

# 还原 iTerm2 配置
plutil -convert binary1 iterm2/com.googlecode.iterm2.plist -o ~/Library/Preferences/com.googlecode.iterm2.plist
```

如需生成可移植的 iTerm2 配置模板：

```bash
# 导出当前配置为 XML 格式
plutil -convert xml1 ~/Library/Preferences/com.googlecode.iterm2.plist -o iterm2/com.googlecode.iterm2.plist

# 将真实 home 目录替换为 $HOME 变量，生成模板文件
sed "s|${HOME}|\\\$HOME|g" iterm2/com.googlecode.iterm2.plist > iterm2/com.googlecode.iterm2.plist.tpl

# 从模板还原配置（将 $HOME 替换为实际路径并转换为二进制格式）
envsubst < iterm2/com.googlecode.iterm2.plist.tpl | plutil -convert binary1 -o ~/Library/Preferences/com.googlecode.iterm2.plist
```

### 默认 Shell 未切换为 Zsh

如果 Shell 未自动切换为 Zsh，请手动执行：

```bash
chsh -s /bin/zsh
```

需要退出并重新登录后才能生效。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件
