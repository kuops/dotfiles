#!/usr/bin/env bash

set -exu
set -o pipefail
set +o posix

HOMEBREW_SET_MIRROR="${HOMEBREW_SET_MIRROR:-true}"
HOMEBREW_MIRROR_SITE="https://mirrors.aliyun.com/homebrew"
HOMEBREW_REPO=$(brew --repo)
HOMEBREW_CASK_REPO=$(brew --repo homebrew/cask)
HOMEBREW_CORE_REPO=$(brew --repo homebrew/core)
INSTALLED_FORMULAS_LIST=()
while IFS='' read -r line; do INSTALLED_FORMULAS_LIST+=("$line"); done < <(brew list --formula)
INSTALLED_CASKS_LIST=()
while IFS='' read -r line; do INSTALLED_CASKS_LIST+=("$line"); done < <(brew list --cask)
HOMEBREW_FORMULAS_LIST=(
  bat
  coreutils
  ctags
  diffutils
  findutils
  gawk
  git
  git-extras
  gnu-getopt
  gnu-tar
  gnu-sed
  go
  grep
  httpie
  htop
  hugo
  iproute2mac
  jenv
  jq
  less
  lrzsz
  lua
  luarocks
  make
  mdbook
  mitmproxy
  moreutils
  mycli
  oath-toolkit
  ranger
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
  clashx
  dash
  docker
  feishu
  gas-mask
  google-chrome
  iterm2
  kindle
  qq
  qqmusic
  sunloginclient
  telegram
  tencent-lemon
  the-unarchiver
  vagrant
  virtualbox
  virtualbox-extension-pack
  wechat
  wireshark
)

check_repo_mirror() {
  if [[ $1 =~ github.com ]];then
    return 0
  else
    return 1
  fi
}

# Install Homebrew
install_homebrew() {
  if ! command -v brew &> /dev/null;then
    # set mirror of Homebrew/brew here
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git" 
    # set mirror of Homebrew/homebrew-core here
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

# Tap the formula repositorys
add_brew_taps() {
  if ! [ -d "$HOMEBREW_CASK_REPO" ];then
    brew tap Homebrew/cask
  fi
  if ! [ -d "$HOMEBREW_CORE_REPO" ];then
    brew tap Homebrew/core
  fi
}

# Install oh-my-zsh and plugins
install_ohmyzsh(){
  if ! [ -d "${HOME}/.oh-my-zsh" ];then
    git clone --depth=1 --branch master "https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh"
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
    git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "${HOME}/.oh-my-zsh/custom/plugins/"
  fi
}

# Change shell to zsh
change_shell(){
  if ! [[ "${SHELL}" =~ "zsh" ]];then
    chsh -s /bin/zsh
  fi
}

# Set homebrew mirrors
set_homebrew_mirror() {
  if [[ ${HOMEBREW_SET_MIRROR} == "true" ]];then
    # shellcheck disable=SC2046
    if check_repo_mirror $(git -C "${HOMEBREW_REPO}" ls-remote --get-url origin);then
      git -C "${HOMEBREW_REPO}" remote set-url origin "${HOMEBREW_MIRROR_SITE}/brew.git"
    fi
    # shellcheck disable=SC2046
    if check_repo_mirror $(git -C "${HOMEBREW_CORE_REPO}" ls-remote --get-url origin);then
      git -C "${HOMEBREW_CORE_REPO}" remote set-url origin "${HOMEBREW_MIRROR_SITE}/homebrew-core.git"
    fi
    # shellcheck disable=SC2046
    if check_repo_mirror $(git -C "${HOMEBREW_CASK_REPO}" ls-remote --get-url origin);then
      git -C "${HOMEBREW_CASK_REPO}" remote set-url origin "${HOMEBREW_MIRROR_SITE}/homebrew-cask.git"
    fi
  fi
}

# Install formulas
install_formulas() {
  NEED_INSTALL_FORMULAS_LIST=()
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
  NEED_INSTALL_CASKS_LIST=()
  for item in "${HOMEBREW_CASKS_LIST[@]}";do
    if ! [[ ${INSTALLED_CASKS_LIST[*]} =~ ${item} ]];then
      NEED_INSTALL_CASKS_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_CASKS_LIST[@]}" -ne 0 ];then
    brew install "${NEED_INSTALL_CASKS_LIST[@]}"
  fi
}

# Install neovim and spacevim
install_neovim() {
  if ! brew list python neovim &> /dev/null;then
    brew install python neovim
  fi
  if ! [ -d "${HOME}/.SpaceVim" ];then
    curl -sLf https://spacevim.org/install.sh | bash -s -- --install neovim
    sh -c 'cd ~/.SpaceVim/bundle/vimproc.vim && make'
  fi
}


# Install pip packages
install_pip_packages(){
  PIP_LIST=(
    neovim
    s3cmd
    ansible
    jedi-language-server
  )
  INSTALLED_PIP_LIST=()
  while IFS='' read -r line; do INSTALLED_PIP_LIST+=("$line"); done < <(pip3 freeze |awk -F '=' '{print $1}')
  NEED_INSTALL_PIP_LIST=()
  for item in "${PIP_LIST[@]}";do
    if ! [[ ${INSTALLED_PIP_LIST[*]} =~ ${item} ]];then
      NEED_INSTALL_PIP_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_PIP_LIST[@]}" -ne 0 ];then
    pip3 install "${NEED_INSTALL_PIP_LIST[@]}"
  fi
}

# Install node
install_node() {
  if ! brew list nvm &> /dev/null;then
    brew install nvm
  fi
  export NVM_DIR="${HOME}/.nvm"
  # shellcheck disable=SC1091
  # shellcheck disable=SC2046
  source $(brew --prefix nvm)/nvm.sh
  if ! nvm list 12 &> /dev/null;then
    nvm install 12
    nvm use 12
    npm install --global yarn
  fi
}

# Install yarn global packages
install_yarn_global_packages() {
  YARN_LIST=(
    bash-language-server
    dockerfile-language-server-nodejs
  )
  INSTALLED_YARN_LIST=()
  YARN_GLOBAL_PACKAGE_JSON="${HOME}/.config/yarn/global/package.json"
  if [ -f "${YARN_GLOBAL_PACKAGE_JSON}" ];then
    while IFS='' read -r line;do
      INSTALLED_YARN_LIST+=("$line")
    done < <(jq -r '.dependencies|keys[]' < "${YARN_GLOBAL_PACKAGE_JSON}")
  fi
  NEED_INSTALL_YARN_LIST=()
  for item in "${YARN_LIST[@]}";do
    if ! [[ ${INSTALLED_YARN_LIST[*]} =~ ${item} ]];then
      NEED_INSTALL_YARN_LIST+=("${item}")
    fi
  done

  if [ "${#NEED_INSTALL_YARN_LIST[@]}" -ne 0 ];then
    yarn global add "${NEED_INSTALL_YARN_LIST[@]}"
  fi
}

# Install java
install_java() {
  HOMEBREW_JAVA_LIST=(
    adoptopenjdk8
    adoptopenjdk16
  )

  NEED_INSTALL_JAVA_LIST=()
  for item in "${HOMEBREW_JAVA_LIST[@]}";do
    if ! [[ ${INSTALLED_CASKS_LIST[*]} =~ ${item} ]];then
      NEED_INSTALL_JAVA_LIST+=("${item}")
    fi
  done

  if [ "${#NEED_INSTALL_JAVA_LIST[@]}" -ne 0 ];then
    brew tap AdoptOpenJDK/openjdk
    brew install "${NEED_INSTALL_JAVA_LIST[@]}"
  fi

  ADOPTOPENJDK8_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/"
  ADOPTOPENJDK16_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-16.jdk/Contents/Home/"

  if ! jenv versions |grep '1.8' &> /dev/null && [ -d ${ADOPTOPENJDK8_HOME} ];then
    jenv add ${ADOPTOPENJDK8_HOME}
  fi

  if ! jenv versions |grep '16' &> /dev/null && [ -d ${ADOPTOPENJDK16_HOME} ];then
    jenv add ${ADOPTOPENJDK16_HOME}
    jenv global 16
    jenv enable-plugin export
    brew install --ignore-dependencies maven
  fi
}

# Install sshpass
install_sshpass() {
  if ! brew list sshpass &> /dev/null;then
    brew install hudochenkov/sshpass/sshpass
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
  if ! diff -q -I 'SSHX.*' -I 'GOPRIVATE.*'  .zshrc "${HOME}/.zshrc" &> /dev/null;then
    [ -f "${HOME}/.zshrc" ] && mv "${HOME}/.zshrc" "${HOME}/.zshrc.bakup.$(date +%F-%H%M%S)"
    cp .zshrc "${HOME}/.zshrc"
  fi
  if ! diff -q .gitconfig "${HOME}/.gitconfig" &> /dev/null;then
    [ -f "${HOME}/.gitconfig" ] && mv "${HOME}/.gitconfig" "${HOME}/.gitconfig.bakup.$(date +%F-%H%M%S)"
    cp .gitconfig "${HOME}/.gitconfig"
  fi
  if ! diff -q .ssh/config "${HOME}/.ssh/config" &> /dev/null;then
    mkdir -p "${HOME}/.ssh"
    [ -f "${HOME}/.ssh/config" ] && mv "${HOME}/.ssh/config" "${HOME}/.ssh/config.bakup.$(date +%F-%H%M%S)"
    cp .ssh/config "${HOME}/.ssh/config"
    chmod 600 "${HOME}/.ssh/config"
  fi
  if ! diff -q .pip/pip.conf "${HOME}/.pip/pip.conf" &> /dev/null;then
    mkdir -p "${HOME}/.pip"
    [ -f "${HOME}/.pip/pip.conf" ] && mv "${HOME}/.pip/pip.conf" "${HOME}/.pip/pip.conf.bakup.$(date +%F-%H%M%S)"
    cp .pip/pip.conf "${HOME}/.pip/pip.conf"
  fi
  if ! diff -q .yarnrc "${HOME}/.yarnrc" &> /dev/null;then
    [ -f "${HOME}/.yarnrc" ] && mv "${HOME}/.yarnrc" "${HOME}/.yarnrc.bakup.$(date +%F-%H%M%S)"
    cp .yarnrc "${HOME}/.yarnrc"
  fi
  if ! diff -q .npmrc "${HOME}/.npmrc" &> /dev/null;then
    [ -f "${HOME}/.npmrc" ] && mv "${HOME}/.npmrc" "${HOME}/.npmrc.bakup.$(date +%F-%H%M%S)"
    cp .npmrc "${HOME}/.npmrc"
  fi
  if ! diff -q .tmux.conf "${HOME}/.tmux.conf" &> /dev/null;then
    [ -f "${HOME}/.tmux.conf" ] && mv "${HOME}/.tmux.conf" "${HOME}/.tmux.conf.bakup.$(date +%F-%H%M%S)"
    cp .tmux.conf "${HOME}/.tmux.conf"
  fi
}

# Set iterm2
set_iterm2() {
  if !  diff iterm2/com.googlecode.iterm2.plist ${HOME}/Library/Preferences/com.googlecode.iterm2.plist &> /dev/null;then
    [ -f "${HOME}/Library/Preferences/com.googlecode.iterm2.plist" ] && mv "${HOME}/Library/Preferences/com.googlecode.iterm2.plist" "${HOME}/Library/Preferences/com.googlecode.iterm2.plist.bakup.$(date +%F-%H%M%S)"
    cp iterm2/com.googlecode.iterm2.plist "${HOME}/Library/Preferences/com.googlecode.iterm2.plist"
  fi
  if ! ls /usr/local/bin/iterm2-*.sh &> /dev/null;then
    cp  iterm2/iterm2-zmodem*.sh /usr/local/bin
  fi
}

# Set kubernetes dev
set_kubernetes_tools() {
  HOMEBREW_KUBE_LIST=(
    kubectl
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
  if [[ ${NEED_INSTALL_KUBE_LIST[*]} =~ kubernetes-cli ]];then
    brew link --overwrite kubernetes-cli
  fi
}

main() {
  install_homebrew
  add_brew_taps
  install_ohmyzsh
  change_shell
  install_formulas
  install_casks
  install_neovim
  install_pip_packages
  install_node
  install_yarn_global_packages
  install_java
  install_sshpass
  set_tmux
  set_iterm2
  set_homebrew_mirror
  update_dotfiles
}

main
