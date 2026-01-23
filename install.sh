#!/usr/bin/env bash

set -e
set -o pipefail
set +o posix

# Homebrew 需要安装的 formulas 软件包列表
HOMEBREW_FORMULAS_LIST=(
  bat
  coreutils
  ctags
  diffutils
  findutils
  fzf
  gawk
  gibo
  git
  git-extras
  gnu-getopt
  gnu-tar
  gnu-sed
  go
  grep
  htop
  hugo
  iproute2mac
  jq
  less
  lrzsz
  lua
  luarocks
  make
  maven
  mdbook
  moreutils
  nmap
  oath-toolkit
  python
  pipx
  ripgrep
  rust
  shellcheck
  sshpass
  telnet
  tig
  tmux
  tokei
  tree
  unzip
  watch
  wtf
  kubernetes-cli
  kubebuilder
  kind
  istioctl
  helm
  kustomize
  kompose
)

# Homebrew 需要安装的 casks 软件包列表
HOMEBREW_CASKS_LIST=(
  adrive
  android-platform-tools
  baidunetdisk
  citrix-workspace
  clash-verge-rev
  claude-code
  docker
  font-cascadia-code-nf
  google-chrome
  graalvm-jdk
  iterm2
  iina
  qq
  qqmusic
  telegram
  tencent-lemon
  tencent-meeting
  vagrant
  virtualbox
  visual-studio-code
  wechat
  wireshark
)

# 设置备份目录变量
BACKUP_DIR="${HOME}/.backup"

# 初始化全局变量 homebrew 已安装软件包列表
INSTALLED_FORMULAS_LIST=()
INSTALLED_CASKS_LIST=()
while IFS='' read -r line; do INSTALLED_FORMULAS_LIST+=("$line"); done < <(brew list --formula)
while IFS='' read -r line; do INSTALLED_CASKS_LIST+=("$line"); done < <(brew list --cask)

# 设置所有国内加速镜像地址
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export NVM_NODEJS_ORG_MIRROR="https://registry.npmmirror.com/node"
PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
NPM_MIRROR_REGISTRY="https://registry.npmmirror.com"

# 创建备份目录
create_backup_dir() {
  if ! [ -d "${BACKUP_DIR}" ]; then
    mkdir -p "${BACKUP_DIR}"
  fi
}

# 安装 homebrew
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

# 安装 ohmyzsh 和自定义插件
install_ohmyzsh() {
  if ! [ -d "${HOME}/.oh-my-zsh" ]; then
    git clone --depth=1 --branch master https://github.com/ohmyzsh/ohmyzsh.git "${HOME}/.oh-my-zsh"
  fi
  if ! [ -d "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
  fi
  if ! [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  fi
  if ! [ -d "${HOME}/.oh-my-zsh/custom/plugins/you-should-use" ]; then
    git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use.git "${HOME}/.oh-my-zsh/custom/plugins/you-should-use"
  fi
  if ! [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  fi
  if ! [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-completions"
  fi
}

# 安装 homebrew formulas 列表中的软件
install_homebrew_formulas_packages() {
  local NEED_INSTALL_FORMULAS_LIST=()
  local item
  for item in "${HOMEBREW_FORMULAS_LIST[@]}"; do
    if ! [[ ${INSTALLED_FORMULAS_LIST[*]} =~ ${item} ]]; then
      NEED_INSTALL_FORMULAS_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_FORMULAS_LIST[@]}" -ne 0 ]; then
    brew install "${NEED_INSTALL_FORMULAS_LIST[@]}"
  fi
}

# 安装 homebrew casks 列表中的软件
install_homebrew_casks_packages() {
  local NEED_INSTALL_CASKS_LIST=()
  local item
  for item in "${HOMEBREW_CASKS_LIST[@]}"; do
    if ! [[ ${INSTALLED_CASKS_LIST[*]} =~ ${item} ]]; then
      NEED_INSTALL_CASKS_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_CASKS_LIST[@]}" -ne 0 ]; then
    brew install --cask "${NEED_INSTALL_CASKS_LIST[@]}"
  fi
}

# 安装 nvm 和 nodejs
install_nvm_nodejs() {
  if ! brew list nvm &>/dev/null; then
    brew install nvm
  fi
  export NVM_DIR="${HOME}/.nvm"
  if brew --prefix nvm &>/dev/null; then
    # shellcheck disable=SC1091
    source "$(brew --prefix nvm)/nvm.sh"
  fi
  if ! nvm list lts/* &>/dev/null; then
    nvm install --lts
    nvm use --lts
  fi
}

# 安装 pnpm 和全局软件包
install_pnpm_global_packages() {
  if ! command -v pnpm &>/dev/null; then
    npm install --global pnpm --registry
    export PNPM_HOME="${HOME}/Library/pnpm"
    export PATH="$PATH:$PNPM_HOME"
  fi
  local PNPM_LIST=(
    @iflow-ai/iflow-cli
    gitmoji-cli
    opencode-ai
  )
  local INSTALLED_PNPM_LIST=()
  local PNPM_GLOBAL_PACKAGE_JSON="${HOME}/Library/pnpm/global/5/package.json"
  if [ -f "${PNPM_GLOBAL_PACKAGE_JSON}" ]; then
    while IFS='' read -r line; do
      INSTALLED_PNPM_LIST+=("$line")
    done < <(jq -r '.dependencies|keys[]' <"${PNPM_GLOBAL_PACKAGE_JSON}")
  fi
  local NEED_INSTALL_PNPM_LIST=()
  local item
  for item in "${PNPM_LIST[@]}"; do
    if ! [[ ${INSTALLED_PNPM_LIST[*]} =~ ${item} ]]; then
      NEED_INSTALL_PNPM_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_PNPM_LIST[@]}" -ne 0 ]; then
    pnpm --global add "${NEED_INSTALL_PNPM_LIST[@]}" --registry "${NPM_MIRROR_REGISTRY}"
  fi
}

# 安装 Python pip 全局软件包
install_pip_packages() {
  local PIP_LIST=(
    s3cmd
    ansible
    ansible-lint
    mycli
    pgcli
    mitmproxy
  )
  local INSTALLED_PIP_LIST=()
  while IFS='' read -r line; do INSTALLED_PIP_LIST+=("$line"); done < <(pipx list --short | awk '{print $1}')
  local NEED_INSTALL_PIP_LIST=()
  for item in "${PIP_LIST[@]}"; do
    if ! [[ ${INSTALLED_PIP_LIST[*]} =~ ${item} ]]; then
      NEED_INSTALL_PIP_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_PIP_LIST[@]}" -ne 0 ]; then
    pipx install --index-url "${PIP_INDEX_URL}" --verbose "${NEED_INSTALL_PIP_LIST[@]}"
  fi
}

# 安装 neovim 和 LazyVim
install_neovim() {
  if ! brew list neovim &>/dev/null; then
    brew install neovim
  fi
  if ! [ -d "${HOME}/.config/nvim" ]; then
    git clone https://github.com/LazyVim/starter "${HOME}/.config/nvim"
    rm -rf ~/.config/nvim/.git
  fi
}

# 设置 tmux
set_tmux() {
  if ! [ -d "${HOME}/.tmux" ]; then
    mkdir -p "${HOME}/.tmux"
  fi
  if ! [ -d "${HOME}/.tmux/plugins/tpm" ]; then
    git clone --depth=1 https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  fi
}

# 更新 dotfiles
update_dotfiles() {
  if ! diff -q .zshrc "${HOME}/.zshrc" &>/dev/null; then
    [ -f "${HOME}/.zshrc" ] && mv "${HOME}/.zshrc" "${BACKUP_DIR}/.zshrc.$(date +%F-%H%M%S)"
    cp .zshrc "${HOME}/.zshrc"
  fi
  if ! diff -q .ssh/config "${HOME}/.ssh/config" &>/dev/null; then
    mkdir -p "${HOME}/.ssh"
    [ -f "${HOME}/.ssh/config" ] && mv "${HOME}/.ssh/config" "${BACKUP_DIR}/ssh_config.$(date +%F-%H%M%S)"
    cp .ssh/config "${HOME}/.ssh/config"
    chmod 600 "${HOME}/.ssh/config"
  fi
  if ! diff -q .pip/pip.conf "${HOME}/.pip/pip.conf" &>/dev/null; then
    mkdir -p "${HOME}/.pip"
    [ -f "${HOME}/.pip/pip.conf" ] && mv "${HOME}/.pip/pip.conf" "${BACKUP_DIR}/pip.conf.$(date +%F-%H%M%S)"
    cp .pip/pip.conf "${HOME}/.pip/pip.conf"
  fi
  if ! diff -q .npmrc "${HOME}/.npmrc" &>/dev/null; then
    [ -f "${HOME}/.npmrc" ] && mv "${HOME}/.npmrc" "${BACKUP_DIR}/.npmrc.$(date +%F-%H%M%S)"
    cp .npmrc "${HOME}/.npmrc"
  fi
  if ! diff -q .tmux.conf "${HOME}/.tmux.conf" &>/dev/null; then
    [ -f "${HOME}/.tmux.conf" ] && mv "${HOME}/.tmux.conf" "${BACKUP_DIR}/.tmux.conf.$(date +%F-%H%M%S)"
    cp .tmux.conf "${HOME}/.tmux.conf"
  fi
}

# 设置 iterm2
set_iterm2() {
  if ! ls /usr/local/bin/iterm2-*.sh &>/dev/null; then
    cp iterm2/iterm2-*.sh /usr/local/bin
    # backup existing iterm2 preferences
    # plutil -convert xml1 ${HOME}/Library/Preferences/com.googlecode.iterm2.plist  -o iterm2/com.googlecode.iterm2.plist
    # change $HOME in template to actual home directory
    #envsubst <iterm2/com.googlecode.iterm2.plist.tpl >iterm2/com.googlecode.iterm2.plist
    # replace iterm2 preferences with the new one
    #plutil -convert binary1 iterm2/com.googlecode.iterm2.plist -o "${HOME}/Library/Preferences/com.googlecode.iterm2.plist"
  fi
}

# 设置 kubectl
set_kubectl() {
  if ! [[ "$(readlink /usr/local/bin/kubectl)" =~ "kubernetes-cli" ]]; then
    brew link --overwrite kubernetes-cli
  fi
}

update_gitconfig() {
  if ! [ -f "${HOME}/.gitconfig" ]; then
    if ! diff -q .gitconfig "${HOME}/.gitconfig" &>/dev/null; then
      [ -f "${HOME}/.gitconfig" ] && mv "${HOME}/.gitconfig" "${BACKUP_DIR}/.gitconfig.$(date +%F-%H%M%S)"
      cp .gitconfig "${HOME}/.gitconfig"
    fi
  fi
}

# Change shell to zsh
chsh_zsh() {
  if ! [[ "${SHELL}" =~ "zsh" ]]; then
    chsh -s /bin/zsh
  fi
}

main() {
  create_backup_dir
  install_homebrew
  install_ohmyzsh
  install_homebrew_formulas_packages
  install_homebrew_casks_packages
  install_nvm_nodejs
  install_pnpm_global_packages
  install_pip_packages
  install_neovim
  set_kubectl
  update_dotfiles
  set_tmux
  set_iterm2
  update_gitconfig
  chsh_zsh
}

main
