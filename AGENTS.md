# AGENTS.md - AI Agent 指导文档

本文档为 AI agents 在此 dotfiles 仓库中工作的提供指导方针。

## 项目概述

这是一个 macOS dotfiles 仓库，包含配置文件和自动化安装脚本，用于设置开发环境。项目包括：

- Shell 配置（Zsh + Oh My Zsh）
- Homebrew 包管理（formulas 和 casks）
- 开发工具（Neovim、Git、Docker、Kubernetes）
- OpenCode Skills 自动化
- iTerm2 终端配置
- 各种 dotfiles（.zshrc、.gitconfig、.tmux.conf 等）

## 构建/检查/测试命令

### Shell 脚本检查

```bash
# 检查所有 shell 脚本
shellcheck install.sh

# 检查特定 shell 脚本
shellcheck path/to/script.sh
```

### 语法检查

```bash
# 检查 bash 语法（不执行）
bash -n install.sh

# 检查 zsh 语法
zsh -n script.sh
```

### 测试安装脚本

```bash
# 运行安装脚本
bash install.sh

# 测试模式（修改时先用 echo 测试）
# 在破坏性命令前添加 echo 进行测试
```

### Makefile 命令

```bash
# 使用 gibo 生成 .gitignore 文件
make gitignore
```

## 代码风格指南

### Shell 脚本（Bash）

#### 脚本头部

```bash
#!/usr/bin/env bash

set -e          # 遇错退出
set -o pipefail # 管道失败传播
set +o posix    # 允许非 POSIX 特性
```

#### 缩进和格式

- 使用 2 空格缩进（按照 .editorconfig）
- 使用 LF 换行符
- UTF-8 编码
- 删除行尾空白
- 文件末尾插入换行符

#### 命名规范

```bash
# 常量和全局变量：SCREAMING_SNAKE_CASE（大写下划线）
BACKUP_DIR="${HOME}/.backup"
HOMEBREW_FORMULAS_LIST=(...)

# 局部变量：小写下划线
local skill_name
local installed_list

# 函数：小写下划线
install_homebrew() {
  # ...
}
```

#### 变量展开

```bash
# 总是引用变量以防止分词
"${HOME}/.config"
"${BACKUP_DIR}/.zshrc.$(date +%F-%H%M%S)"

# 使用 ${} 表示变量名
"${variable_name}"

# 命令替换：使用 $() 而不是反引号
$(date +%F-%H%M%S)
```

#### 数组

```bash
# 数组声明
local SKILLS_LIST=(
  "item1"
  "item2"
)

# 数组迭代
for item in "${ARRAY[@]}"; do
  echo "${item}"
done

# 读取行到数组
while IFS='' read -r line; do ARRAY+=("$line"); done < <(command)
```

#### 条件判断

```bash
# 使用双括号进行测试
if [[ "${variable}" =~ "pattern" ]]; then
  # ...
fi

# 检查命令是否存在
if ! command -v brew &>/dev/null; then
  # ...
fi

# 检查文件/目录是否存在
if ! [ -d "${HOME}/.config" ]; then
  # ...
fi

# 检查 diff 是否静默
if ! diff -q file1 file2 &>/dev/null; then
  # ...
fi
```

#### 错误处理

```bash
# 重定向 stdout 和 stderr 到 /dev/null
command &>/dev/null

# 仅重定向 stderr
command 2>/dev/null

# 管道失败由 set -o pipefail 捕获
command1 | command2
```

#### 函数

```bash
# 函数结构
function_name() {
  local local_var="value"
  
  # 函数逻辑
  if ! command; then
    echo "错误信息"
    return 1
  fi
  
  # 成功
  echo "成功信息"
}
```

### Markdown 文件

- 使用 4 空格缩进（按照 .editorconfig）
- 不要删除行尾空白（按照 .editorconfig）
- 使用 UTF-8 编码
- 使用 LF 换行符

### Git 提交信息

使用 gitmoji 格式：

```bash
✨ 添加新功能
📝 更新文档
🐛 修复 bug
✏️ 修正错别字
🔧 更新配置
➖ 移除依赖
```

格式：`<gitmoji> <描述>`

示例：
- `✨ 添加 opencode skills 自动安装功能`
- `📝 简化 Microsoft Office 安装文档`

## 仓库结构

```
dotfiles/
├── .config/          # 应用配置
├── .pip/             # pip 配置
├── .ssh/             # SSH 配置
├── .vscode/          # VS Code 设置
├── iterm2/           # iTerm2 脚本和配置
├── install.sh        # 主安装脚本
├── .editorconfig     # 编辑器配置
├── .gitconfig        # Git 配置
├── .gitignore        # Git 忽略规则
├── .npmrc            # npm 配置
├── .tmux.conf        # tmux 配置
├── .zshrc            # Zsh 配置
├── Makefile          # 构建自动化
├── README.md         # 英文文档
└── README.zh-CN.md   # 中文文档
```

## 重要指南

### 修改 install.sh 时

1. 在覆盖文件前始终保留备份机制
2. 在顶部使用 `set -e` 和 `set -o pipefail`
3. 运行前用 `bash -n install.sh` 测试语法
4. 运行 `shellcheck install.sh` 捕获常见问题
5. 保持函数模块化和单一职责
6. 使用描述性函数名：`install_*`、`set_*`、`update_*`

### 添加新 Skills 时

1. 使用 `npx skills find <query>` 搜索 skill
2. 使用 `npx skills list -g` 验证安装
3. 添加到 `install_opencode_skills()` 函数的 `SKILLS_LIST` 数组
4. 同时更新 README.md 和 README.zh-CN.md

### 使用 Homebrew 时

1. 安装前检查包是否已安装
2. 使用数组管理包列表：`HOMEBREW_FORMULAS_LIST` 和 `HOMEBREW_CASKS_LIST`
3. 脚本化前手动测试安装命令
4. 将 formulas 和 casks 分别放在不同的列表中

### 文档更新

1. 同时更新英文（README.md）和中文（README.zh-CN.md）版本
2. 使用 gitmoji 保持提交信息简洁
3. 文档化前测试所有命令和代码块
4. 在两个语言版本中保持一致的格式

## 测试清单

提交更改前：

- [ ] 运行 `bash -n install.sh` 检查语法
- [ ] 运行 `shellcheck install.sh` 进行检查
- [ ] 单独测试修改的函数
- [ ] 如果行为改变，更新文档
- [ ] 验证提交信息遵循 gitmoji 格式
- [ ] 检查更改不会破坏现有安装
