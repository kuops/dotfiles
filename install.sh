#!/usr/bin/env bash

set -e
set -o pipefail
set +o posix

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
  jenv
  jq
  less
  lrzsz
  lua
  luarocks
  make
  mdbook
  moreutils
  oath-toolkit
  python
  ripgrep
  shellcheck
  telnet
  tig
  tmux
  tokei
  tree
  unzip
  watch
  wtf
)

HOMEBREW_CASKS_LIST=(
  android-platform-tools
  clashx-pro
  dash
  docker
  feishu
  gas-mask
  google-chrome
  iterm2
  iina
  kindle
  kodi
  qq
  qqmusic
  telegram
  tencent-lemon
  tencent-meeting
  the-unarchiver
  vagrant
  virtualbox
  visual-studio-code
  wechat
  wechatwork
  wireshark
  wpsoffice
)

BACKUP_DIR="${HOME}/.backup"

# Create backup dir
create_backup_dir() {
  if ! [ -d "${BACKUP_DIR}" ];then
    mkdir -p "${BACKUP_DIR}"
  fi
}

# Install homebrew
install_homebrew() {
  if ! command -v brew &> /dev/null;then
    # Set mirror of Homebrew/brew here
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
    # Set mirror of Homebrew/homebrew-core here
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
    # Set mirror of Homebrew/homebrew-cask here
    export HOMEBREW_CASK_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-cask.git"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

# Set homebrew env
set_homebrew_env(){
  INSTALLED_FORMULAS_LIST=()
  INSTALLED_CASKS_LIST=()
  while IFS='' read -r line; do INSTALLED_FORMULAS_LIST+=("$line"); done < <(brew list --formula)
  while IFS='' read -r line; do INSTALLED_CASKS_LIST+=("$line"); done < <(brew list --cask)
}

# Tap the formula repositorys
add_homebrew_taps() {
  local HOMEBREW_CASK_REPO
  local HOMEBREW_CORE_REPO
  HOMEBREW_CASK_REPO=$(brew --repo homebrew/cask)
  HOMEBREW_CORE_REPO=$(brew --repo homebrew/core)
  if ! [ -d "$HOMEBREW_CASK_REPO" ];then
    brew tap --custom-remote --force-auto-update homebrew/cask https://mirrors.ustc.edu.cn/homebrew-cask.git
  fi
  if ! [ -d "$HOMEBREW_CORE_REPO" ];then
    brew tap --custom-remote --force-auto-update homebrew/core https://mirrors.ustc.edu.cn/homebrew-core.git
  fi

}

# Install oh-my-zsh and plugins
install_ohmyzsh(){
  if ! [ -d "${HOME}/.oh-my-zsh" ];then
    git clone --depth=1 --branch master https://github.com/ohmyzsh/ohmyzsh.git "${HOME}/.oh-my-zsh"
  fi
  if ! [ -d "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ];then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
  fi
  if ! [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ];then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  fi
  if ! [ -d "${HOME}/.oh-my-zsh/custom/plugins/you-should-use" ];then
    git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use.git "${HOME}/.oh-my-zsh/custom/plugins/you-should-use"
  fi
  if ! [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ];then
    git clone --depth=1  https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  fi
  if ! [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-completions" ];then
    git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-completions"
  fi
}

# Change shell to zsh
chsh_zsh(){
  if ! [[ "${SHELL}" =~ "zsh" ]];then
    chsh -s /bin/zsh
  fi
}

# Install formulas
install_formulas() {
  local NEED_INSTALL_FORMULAS_LIST=()
  local item
  for item in "${HOMEBREW_FORMULAS_LIST[@]}";do
    if ! [[ ${INSTALLED_FORMULAS_LIST[*]} =~ ${item} ]];then
      NEED_INSTALL_FORMULAS_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_FORMULAS_LIST[@]}" -ne 0 ];then
    brew install "${NEED_INSTALL_FORMULAS_LIST[@]}"
  fi
}

# Install casks
install_casks() {
  local NEED_INSTALL_CASKS_LIST=()
  local item
  for item in "${HOMEBREW_CASKS_LIST[@]}";do
    if ! [[ ${INSTALLED_CASKS_LIST[*]} =~ ${item} ]];then
      NEED_INSTALL_CASKS_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_CASKS_LIST[@]}" -ne 0 ];then
    brew install --cask "${NEED_INSTALL_CASKS_LIST[@]}"
  fi
}

# Install neovim and spacevim
install_neovim() {
  if ! brew list neovim &> /dev/null;then
    brew install neovim
  fi
  if ! [ -d "${HOME}/.SpaceVim" ];then
    curl -sLf https://spacevim.org/install.sh | bash -s -- --install neovim
  fi
}

# Install pip packages
install_pip_packages(){
  local PIP_LIST=(
    neovim
    s3cmd
    ansible
    ansible-lint
    jedi-language-server
    httpie
    ranger-fm
    mycli
    mitmproxy
  )
  local INSTALLED_PIP_LIST=()
  while IFS='' read -r line; do INSTALLED_PIP_LIST+=("$line"); done < <(pip3 freeze |awk -F '=' '{print $1}')
  local NEED_INSTALL_PIP_LIST=()
  for item in "${PIP_LIST[@]}";do
    if ! [[ ${INSTALLED_PIP_LIST[*]} =~ ${item} ]];then
      NEED_INSTALL_PIP_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_PIP_LIST[@]}" -ne 0 ];then
    pip3 install "${NEED_INSTALL_PIP_LIST[@]}" -i https://mirrors.aliyun.com/pypi/simple/
  fi
}

# Install node
install_node() {
  if ! brew list nvm &> /dev/null;then
    brew install nvm
  fi
  export NVM_DIR="${HOME}/.nvm"
  if brew --prefix nvm &> /dev/null;then
    # shellcheck disable=SC1091
    source "$(brew --prefix nvm)/nvm.sh"
  fi
  if ! nvm list stable &> /dev/null;then
    nvm install stable
    nvm use stable
    npm install --global yarn
  fi
}

# Install yarn global packages
install_yarn_global_packages() {
  local YARN_LIST=(
    bash-language-server
    dockerfile-language-server-nodejs
    gitmoji-cli
    prettier
  )
  local INSTALLED_YARN_LIST=()
  local YARN_GLOBAL_PACKAGE_JSON="${HOME}/.config/yarn/global/package.json"
  if [ -f "${YARN_GLOBAL_PACKAGE_JSON}" ];then
    while IFS='' read -r line;do
      INSTALLED_YARN_LIST+=("$line")
    done < <(jq -r '.dependencies|keys[]' < "${YARN_GLOBAL_PACKAGE_JSON}")
  fi
  local NEED_INSTALL_YARN_LIST=()
  local item
  for item in "${YARN_LIST[@]}";do
    if ! [[ ${INSTALLED_YARN_LIST[*]} =~ ${item} ]];then
      NEED_INSTALL_YARN_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_YARN_LIST[@]}" -ne 0 ];then
    yarn global add "${NEED_INSTALL_YARN_LIST[@]}" --registry https://registry.npm.taobao.org/
  fi
}

# Install java
install_java() {
  local HOMEBREW_CASK_VERSIONS_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-cask-versions.git"
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
  local HOMEBREW_JAVA_LIST=(
    temurin
    temurin8
  )
  local NEED_INSTALL_JAVA_LIST=()
  for item in "${HOMEBREW_JAVA_LIST[@]}";do
    if ! [[ ${INSTALLED_CASKS_LIST[*]} =~ ${item} ]];then
      NEED_INSTALL_JAVA_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_JAVA_LIST[@]}" -ne 0 ];then
    brew tap --custom-remote --force-auto-update homebrew/cask-versions ${HOMEBREW_CASK_VERSIONS_GIT_REMOTE}
    brew install --cask "${NEED_INSTALL_JAVA_LIST[@]}"
  fi
  local JAVA8_HOME
  JAVA8_HOME="$(/usr/libexec/java_home -v 1.8)"
  if ! jenv versions |grep '1.8' &> /dev/null && [ -d "${JAVA8_HOME}" ];then
    jenv add "${JAVA8_HOME}"
  fi
  if ! jenv plugins --enabled|grep export &> /dev/null;then
    jenv enable-plugin export
  fi
  if ! jenv plugins --enabled|grep maven &> /dev/null;then
    jenv enable-plugin maven
  fi
  if ! command -v mvn &> /dev/null;then
    brew install --ignore-dependencies maven
  fi
}

# Install local formulas
install_local_formulas() {
  if ! brew list sshpass &> /dev/null;then
    brew install ./homebrew/sshpass.rb
  fi
  if ! [ -f /usr/local/bin/ip ];then
    curl -sSLo /usr/local/bin/ip https://github.com/brona/iproute2mac/raw/master/src/ip.py
    chmod +x /usr/local/bin/ip
  fi
}

# Set tmux
set_tmux() {
  if ! [ -d "${HOME}/.tmux" ];then
    mkdir -p "${HOME}/.tmux"
  fi
  if ! [ -d "${HOME}/.tmux/plugins/tpm" ];then
    git clone --depth=1 https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  fi
}

# Update dotfiles
update_dotfiles() {
  if ! diff -q .zshrc "${HOME}/.zshrc" &> /dev/null;then
    [ -f "${HOME}/.zshrc" ] && mv "${HOME}/.zshrc" "${BACKUP_DIR}/.zshrc.$(date +%F-%H%M%S)"
    cp .zshrc "${HOME}/.zshrc"
  fi
  if ! diff -q .ssh/config "${HOME}/.ssh/config" &> /dev/null;then
    mkdir -p "${HOME}/.ssh"
    [ -f "${HOME}/.ssh/config" ] && mv "${HOME}/.ssh/config" "${BACKUP_DIR}/ssh_config.$(date +%F-%H%M%S)"
    cp .ssh/config "${HOME}/.ssh/config"
    chmod 600 "${HOME}/.ssh/config"
  fi
  if ! diff -q .pip/pip.conf "${HOME}/.pip/pip.conf" &> /dev/null;then
    mkdir -p "${HOME}/.pip"
    [ -f "${HOME}/.pip/pip.conf" ] && mv "${HOME}/.pip/pip.conf" "${BACKUP_DIR}/pip.conf.$(date +%F-%H%M%S)"
    cp .pip/pip.conf "${HOME}/.pip/pip.conf"
  fi
  if ! diff -q .yarnrc "${HOME}/.yarnrc" &> /dev/null;then
    [ -f "${HOME}/.yarnrc" ] && mv "${HOME}/.yarnrc" "${BACKUP_DIR}/.yarnrc.$(date +%F-%H%M%S)"
    cp .yarnrc "${HOME}/.yarnrc"
  fi
  if ! diff -q .npmrc "${HOME}/.npmrc" &> /dev/null;then
    [ -f "${HOME}/.npmrc" ] && mv "${HOME}/.npmrc" "${BACKUP_DIR}/.npmrc.$(date +%F-%H%M%S)"
    cp .npmrc "${HOME}/.npmrc"
  fi
  if ! diff -q .tmux.conf "${HOME}/.tmux.conf" &> /dev/null;then
    [ -f "${HOME}/.tmux.conf" ] && mv "${HOME}/.tmux.conf" "${BACKUP_DIR}/.tmux.conf.$(date +%F-%H%M%S)"
    cp .tmux.conf "${HOME}/.tmux.conf"
  fi
  if ! diff -qdur .SpaceVim.d "${HOME}/.SpaceVim.d" &> /dev/null;then
    [ -d "${HOME}/.SpaceVim.d" ] && mv "${HOME}/.SpaceVim.d" "${BACKUP_DIR}/.SpaceVim.d.$(date +%F-%H%M%S)"
    cp -r .SpaceVim.d "${HOME}/.SpaceVim.d"
  fi
  if ! diff -q .fzf.zsh "${HOME}/.fzf.zsh" &> /dev/null;then
    cp .fzf.zsh "${HOME}/.fzf.zsh"
  fi
}

# Set iterm2
set_iterm2() {
  local style
  local FONT_BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
  for style in Regular Bold Italic 'Bold Italic'; do
    local FONT_FILE="MesloLGS NF ${style}.ttf"
    if ! [ -f "${HOME}/Library/Fonts/$FONT_FILE" ];then
      curl -fsSL -o "${HOME}/Library/Fonts/$FONT_FILE" "$FONT_BASE_URL/${FONT_FILE// /%20}"
    fi
  done
  if ! ls /usr/local/bin/iterm2-*.sh &> /dev/null;then
    cp iterm2/iterm2-*.sh /usr/local/bin
    plutil -convert binary1 iterm2/com.googlecode.iterm2.plist -o "${HOME}/Library/Preferences/com.googlecode.iterm2.plist"
  fi
}

# Install kubernetes tools
install_kubernetes_tools() {
  HOMEBREW_KUBE_LIST=(
    kubernetes-cli
    kubebuilder
    kind
    istioctl
    helm
    kustomize
    kompose
  )
  NEED_INSTALL_KUBE_LIST=()
  for item in "${HOMEBREW_KUBE_LIST[@]}";do
    if ! [[ ${INSTALLED_FORMULAS_LIST[*]} =~ ${item} ]];then
      NEED_INSTALL_KUBE_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_KUBE_LIST[@]}" -ne 0 ];then
    brew install "${NEED_INSTALL_KUBE_LIST[@]}"
  fi
  if ! [[ "$(readlink /usr/local/bin/kubectl)" =~ "kubernetes-cli" ]];then
    brew link --overwrite kubernetes-cli
  fi
}

update_gitconfig() {
  if ! diff -q .gitconfig "${HOME}/.gitconfig" &> /dev/null;then
    [ -f "${HOME}/.gitconfig" ] && mv "${HOME}/.gitconfig" "${BACKUP_DIR}/.gitconfig.$(date +%F-%H%M%S)"
    cp .gitconfig "${HOME}/.gitconfig"
  fi
}

main() {
  create_backup_dir
  install_homebrew
  set_homebrew_env
  add_homebrew_taps
  install_ohmyzsh
  install_formulas
  install_casks
  install_node
  install_yarn_global_packages
  install_pip_packages
  install_neovim
  install_local_formulas
  install_java
  install_kubernetes_tools
  update_dotfiles
  set_tmux
  set_iterm2
  update_gitconfig
  chsh_zsh
}

main
