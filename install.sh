#!/usr/bin/env bash

set -e
set -o pipefail
set +o posix

# Homebrew 需要安装的 formulas 软件包列表
HOMEBREW_FORMULAS_LIST=(
  coreutils
  ctags
  diffutils
  findutils
  fzf
  gawk
  gh
  gibo
  git
  git-extras
  gnu-getopt
  gnu-tar
  gnu-sed
  go
  grep
  hugo
  iproute2mac
  jq
  k6
  less
  lrzsz
  lua
  luarocks
  make
  maven
  mdbook
  moreutils
  neovim
  nmap
  oath-toolkit
  opencode
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
  docker
  feishu
  font-cascadia-code-nf
  google-chrome
  graalvm-jdk
  iterm2
  iina
  microsoft-excel
  microsoft-powerpoint
  microsoft-word
  obsidian
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
if command -v brew &>/dev/null; then
  while IFS='' read -r line; do INSTALLED_FORMULAS_LIST+=("$line"); done < <(brew list --formula)
  while IFS='' read -r line; do INSTALLED_CASKS_LIST+=("$line"); done < <(brew list --cask)
fi

# 设置所有国内加速镜像地址
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
PIP_INDEX_URL="https://mirrors.ustc.edu.cn/pypi/simple"
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
  local OHMYZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
  local ZSH_THEMES=(
    "powerlevel10k|https://github.com/romkatv/powerlevel10k.git"
  )
  local ZSH_PLUGINS=(
    "zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions.git"
    "you-should-use|https://github.com/MichaelAquilina/zsh-you-should-use.git"
    "zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting.git"
    "zsh-completions|https://github.com/zsh-users/zsh-completions.git"
  )
  local item name url dir
  for item in "${ZSH_THEMES[@]}"; do
    name="${item%%|*}"
    url="${item##*|}"
    dir="${OHMYZSH_CUSTOM}/themes/${name}"
    if ! [ -d "${dir}" ]; then
      git clone --depth=1 "${url}" "${dir}"
    fi
  done
  for item in "${ZSH_PLUGINS[@]}"; do
    name="${item%%|*}"
    url="${item##*|}"
    dir="${OHMYZSH_CUSTOM}/plugins/${name}"
    if ! [ -d "${dir}" ]; then
      git clone --depth=1 "${url}" "${dir}"
    fi
  done
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
  local nvm_prefix
  nvm_prefix="$(brew --prefix nvm)"
  if [ -d "${nvm_prefix}" ]; then
    # shellcheck disable=SC1091
    source "${nvm_prefix}/nvm.sh"
  fi
  if ! [ -f "${HOME}/.nvm/alias/default" ]; then
    nvm install --lts
    nvm use --lts
  fi
}

# 安装 npm 全局软件包
install_npm_global_packages() {
  local NPM_LIST=(
    agent-browser
    skills
  )
  local INSTALLED_NPM_LIST=()
  local NPM_GLOBAL_PACKAGE_JSON
  NPM_GLOBAL_PACKAGE_JSON=$(npm list --depth=0 --json -g)
  while IFS='' read -r line; do
    INSTALLED_NPM_LIST+=("$line")
  done < <(echo "${NPM_GLOBAL_PACKAGE_JSON}" | jq -r '.dependencies|keys[]')
  local NEED_INSTALL_NPM_LIST=()
  local item
  for item in "${NPM_LIST[@]}"; do
    if ! [[ ${INSTALLED_NPM_LIST[*]} =~ ${item} ]]; then
      NEED_INSTALL_NPM_LIST+=("${item}")
    fi
  done
  if [ "${#NEED_INSTALL_NPM_LIST[@]}" -ne 0 ]; then
    npm install -g "${NEED_INSTALL_NPM_LIST[@]}" --registry "${NPM_MIRROR_REGISTRY}"
  fi
}

# 安装 opencode skills
install_opencode_skills() {
  if ! command -v skills &>/dev/null; then
    echo "skills 命令未安装，跳过 opencode skills 安装"
    return 0
  fi
  local SKILLS_LIST=(
    "https://github.com/nextlevelbuilder/ui-ux-pro-max-skill|ui-ux-pro-max"
    "https://github.com/anthropics/skills|skill-creator"
    "https://github.com/anthropics/skills|mcp-builder"
    "https://github.com/anthropics/skills|pptx"
    "https://github.com/anthropics/skills|docx"
    "https://github.com/anthropics/skills|xlsx"
    "https://github.com/wshobson/agents|bash-defensive-patterns"
    "https://github.com/wshobson/agents|api-design-principles"
    "https://github.com/wshobson/agents|architecture-patterns"
    "https://github.com/wshobson/agents|tailwind-design-system"
    "https://github.com/vercel-labs/agent-skills|vercel-react-best-practices"
    "https://github.com/kepano/obsidian-skills|obsidian-bases"
    "https://github.com/kepano/obsidian-skills|obsidian-markdown"
    "https://github.com/kepano/obsidian-skills|obsidian-cli"
    "https://github.com/kepano/obsidian-skills|json-canvas"
  )
  local item repo skill_name
  for item in "${SKILLS_LIST[@]}"; do
    repo="${item%%|*}"
    skill_name="${item##*|}"
    if [ -f "${HOME}/.agents/skills/${skill_name}/SKILL.md" ]; then
      continue
    fi
    skills add "${repo}" --skill "${skill_name}" -y -g || echo "安装 skill ${skill_name} 失败，跳过"
  done
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

# 安装 LazyVim
set_neovim() {
  if ! [ -d "${HOME}/.config/nvim" ]; then
    git clone --depth=1 https://github.com/LazyVim/starter "${HOME}/.config/nvim"
    rm -rf "${HOME}/.config/nvim/.git"
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
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_and_copy() {
  local src="$1"
  local dest="$2"
  local backup_name="$3"
  if ! diff -q "${src}" "${dest}" &>/dev/null; then
    [ -f "${dest}" ] && mv "${dest}" "${BACKUP_DIR}/${backup_name}.$(date +%F-%H%M%S)"
    mkdir -p "$(dirname "${dest}")"
    cp "${src}" "${dest}"
  fi
}
update_dotfiles() {
  cd "${DOTFILES_DIR}"
  backup_and_copy .zshrc "${HOME}/.zshrc" ".zshrc"
  backup_and_copy .ssh/config "${HOME}/.ssh/config" "ssh_config"
  chmod 600 "${HOME}/.ssh/config"
  backup_and_copy .pip/pip.conf "${HOME}/.pip/pip.conf" "pip.conf"
  backup_and_copy .npmrc "${HOME}/.npmrc" ".npmrc"
  backup_and_copy .tmux.conf "${HOME}/.tmux.conf" ".tmux.conf"
  backup_and_copy .config/nvim/lua/config/options.lua "${HOME}/.config/nvim/lua/config/options.lua" "nvim_options.lua"
  backup_and_copy .config/opencode/opencode.json "${HOME}/.config/opencode/opencode.json" "opencode.json"
  backup_and_copy .config/opencode/AGENTS.md "${HOME}/.config/opencode/AGENTS.md" "opencode_AGENTS.md"
  backup_and_copy .gitconfig "${HOME}/.gitconfig" ".gitconfig"
}

# 设置 iterm2
set_iterm2_zmodem() {
  local script_base_path="/usr/local/bin"
  local src_file
  for src_file in "${DOTFILES_DIR}"/iterm2/iterm2-*.sh; do
    [ -f "${src_file}" ] || continue
    local base_name
    base_name="$(basename "${src_file}")"
    if ! [ -f "${script_base_path}/${base_name}" ]; then
      cp "${src_file}" "${script_base_path}/"
      chmod +x "${script_base_path}/${base_name}"
    fi
  done
}

# 设置 kubectl
set_kubectl() {
  if ! [[ "$(readlink /usr/local/bin/kubectl)" =~ "kubernetes-cli" ]]; then
    brew link --overwrite kubernetes-cli
  fi
}

# 修改 shell 为 zsh
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
  install_npm_global_packages
  install_opencode_skills
  install_pip_packages
  set_neovim
  set_kubectl
  update_dotfiles
  set_tmux
  set_iterm2_zmodem
  chsh_zsh
}

main
