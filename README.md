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
ALL_PROXY="proxy_ip:port"
NO_PROXY=".cn,.taobao.org,.aliyun.com,localhost,127.0.0.1"
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
# nvm install nodejs 8
nvm install 8
# switch to version 8
nvm use 8
```

jenv switch java version

```bash
# list versions
jenv versions
# switch to java 8
jenv global 1.8
# local version
jenv local 17
```
