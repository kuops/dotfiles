# dotfiles

My macOS dotfiles and homebrew applications.

> :cn: all package manager toools configured china mirror.

## Installation

Install xcode command line tools:

```bash
xcode-select --install
```

Git clone this repository:

```bash
git clone git@github.com:kuops/dotfiles.git
```

Set command line proxy:

```bash
export ALL_PROXY="proxy_ip:port"
export NO_PROXY=".cn,.npmmirror.com,.aliyun.com,localhost,127.0.0.1"
```

Running script `install.sh`:

The script will:

-   Install homebrew.
-   Set homebrew china mirrors.
-   Install popular applications and command line tools.
-   Install ohmyzsh and change shell to zsh.
-   Install neovim and spacevim settings.
-   Set pip,yarn,npm,git,ssh preferences.
-   Set Iterm2 plist preferences.

```bash
cd dotfiles && bash install.sh
```

## Others

tmux install plugin use tpm:

```bash
prefix(ctrl + a) + I
```

update spacevim plugins:

```bash
vim -c SPUpdate
```

update pip plugins:

```bash
pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
```

nvm install other nodejs:

```bash
# nvm install nodejs version x
nvm install 8
# switch once version x
nvm use 8
# switch global version x
nvm alias default 8
```

jenv switch java version

```bash
# list versions
jenv versions
# global switch to java 8
jenv global 1.8
# current directory project switch to java 8
jenv local 1.8
```
