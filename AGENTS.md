# AGENTS.md - AI Agent Guidelines

This document provides guidelines for AI agents working on this dotfiles repository.

## Project Overview

This is a macOS dotfiles repository containing configuration files and an automated installation script for setting up a development environment. The project includes:

- Shell configuration (Zsh with Oh My Zsh)
- Homebrew package management (formulas and casks)
- Development tools (Neovim, Git, Docker, Kubernetes)
- OpenCode Skills automation
- iTerm2 terminal configuration
- Various dotfiles (.zshrc, .gitconfig, .tmux.conf, etc.)

## Build/Lint/Test Commands

### Linting Shell Scripts

```bash
# Lint all shell scripts
shellcheck install.sh

# Lint specific shell script
shellcheck path/to/script.sh
```

### Syntax Checking

```bash
# Check bash syntax without executing
bash -n install.sh

# Check zsh syntax
zsh -n script.sh
```

### Testing Installation Script

```bash
# Run the installation script
bash install.sh

# Dry-run mode (if modifying, test with echo first)
# Add echo before destructive commands during testing
```

### Makefile Commands

```bash
# Generate .gitignore file using gibo
make gitignore
```

## Code Style Guidelines

### Shell Scripts (Bash)

#### Script Header

```bash
#!/usr/bin/env bash

set -e          # Exit on error
set -o pipefail # Pipe failures propagate
set +o posix    # Allow non-POSIX features
```

#### Indentation & Formatting

- Use 2 spaces for indentation (per .editorconfig)
- Use LF line endings
- UTF-8 encoding
- Trim trailing whitespace
- Insert final newline

#### Naming Conventions

```bash
# Constants and global variables: SCREAMING_SNAKE_CASE
BACKUP_DIR="${HOME}/.backup"
HOMEBREW_FORMULAS_LIST=(...)

# Local variables: lowercase with underscores
local skill_name
local installed_list

# Functions: lowercase with underscores
install_homebrew() {
  # ...
}
```

#### Variable Expansion

```bash
# Always quote variables to prevent word splitting
"${HOME}/.config"
"${BACKUP_DIR}/.zshrc.$(date +%F-%H%M%S)"

# Use ${} for variable names
"${variable_name}"

# Command substitution: use $() instead of backticks
$(date +%F-%H%M%S)
```

#### Arrays

```bash
# Array declaration
local SKILLS_LIST=(
  "item1"
  "item2"
)

# Array iteration
for item in "${ARRAY[@]}"; do
  echo "${item}"
done

# Read lines into array
while IFS='' read -r line; do ARRAY+=("$line"); done < <(command)
```

#### Conditionals

```bash
# Use double brackets for tests
if [[ "${variable}" =~ "pattern" ]]; then
  # ...
fi

# Check command existence
if ! command -v brew &>/dev/null; then
  # ...
fi

# Check file/directory existence
if ! [ -d "${HOME}/.config" ]; then
  # ...
fi

# Check if diff is silent
if ! diff -q file1 file2 &>/dev/null; then
  # ...
fi
```

#### Error Handling

```bash
# Redirect stdout and stderr to /dev/null
command &>/dev/null

# Redirect stderr only
command 2>/dev/null

# Pipe failures are caught by set -o pipefail
command1 | command2
```

#### Functions

```bash
# Function structure
function_name() {
  local local_var="value"
  
  # Function logic
  if ! command; then
    echo "Error message"
    return 1
  fi
  
  # Success
  echo "Success message"
}
```

### Markdown Files

- Use 4 spaces for indentation (per .editorconfig)
- Do NOT trim trailing whitespace (per .editorconfig)
- Use UTF-8 encoding
- Use LF line endings

### Git Commit Messages

Use gitmoji format:

```bash
✨ Add new feature
📝 Update documentation
🐛 Fix bug
✏️ Fix typo
🔧 Update configuration
➖ Remove dependency
```

Format: `<gitmoji> <description>`

Examples:
- `✨ Add opencode skills auto-install feature`
- `📝 Simplify Microsoft Office installation documentation`

## Repository Structure

```
dotfiles/
├── .config/          # Application configs
├── .pip/             # pip configuration
├── .ssh/             # SSH config
├── .vscode/          # VS Code settings
├── iterm2/           # iTerm2 scripts and configs
├── install.sh        # Main installation script
├── .editorconfig     # Editor configuration
├── .gitconfig        # Git configuration
├── .gitignore        # Git ignore rules
├── .npmrc            # npm configuration
├── .tmux.conf        # tmux configuration
├── .zshrc            # Zsh configuration
├── Makefile          # Build automation
├── README.md         # English documentation
└── README.zh-CN.md   # Chinese documentation
```

## Important Guidelines

### When Modifying install.sh

1. Always maintain the backup mechanism before overwriting files
2. Use `set -e` and `set -o pipefail` at the top
3. Test syntax with `bash -n install.sh` before running
4. Run `shellcheck install.sh` to catch common issues
5. Keep functions modular and single-purpose
6. Use descriptive function names: `install_*`, `set_*`, `update_*`

### When Adding New Skills

1. Search for the skill using `npx skills find <query>`
2. Verify installation with `npx skills list -g`
3. Add to `SKILLS_LIST` array in `install_opencode_skills()` function
4. Update both README.md and README.zh-CN.md

### When Working with Homebrew

1. Check if package is already installed before installing
2. Use arrays for package lists: `HOMEBREW_FORMULAS_LIST` and `HOMEBREW_CASKS_LIST`
3. Test installation commands manually before scripting
4. Keep formulas and casks in separate lists

### Documentation Updates

1. Update both English (README.md) and Chinese (README.zh-CN.md) versions
2. Keep commit messages concise using gitmoji
3. Test all commands and code blocks before documenting
4. Maintain consistent formatting across both language versions

## Testing Checklist

Before committing changes:

- [ ] Run `bash -n install.sh` to check syntax
- [ ] Run `shellcheck install.sh` to lint
- [ ] Test modified functions in isolation
- [ ] Update documentation if behavior changes
- [ ] Verify commit message follows gitmoji format
- [ ] Check that changes don't break existing installations
