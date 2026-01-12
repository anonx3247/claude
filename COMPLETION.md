# Shell Completion for cft and cftr

Auto-completion makes using `cft` and `cftr` faster and more convenient by suggesting branch names as you type.

## Features

- **Branch name completion** for `cft` - suggests existing branches and allows custom names
- **Worktree completion** for `cftr` - suggests active worktrees that can be removed
- **Context-aware** - only shows relevant options

## Installation

### Zsh (macOS default, Oh My Zsh)

**Method 1: Source directly (easiest)**

Add to your `~/.zshrc`:

```bash
# Claude worktree completions
source /path/to/repo/completions.zsh
```

Reload:
```bash
source ~/.zshrc
```

**Method 2: Install in completion directory**

```bash
# Create completions directory if it doesn't exist
mkdir -p ~/.zsh/completions

# Copy the completion script
cp completions.zsh ~/.zsh/completions/_cft_cftr

# Add to ~/.zshrc (if not already there)
echo 'fpath=(~/.zsh/completions $fpath)' >> ~/.zshrc
echo 'autoload -Uz compinit && compinit' >> ~/.zshrc

# Reload
source ~/.zshrc
```

**Method 3: Oh My Zsh custom completions**

If using Oh My Zsh:

```bash
# Copy to custom completions
cp completions.zsh ~/.oh-my-zsh/custom/plugins/cft-cftr.plugin.zsh

# It will be auto-loaded on next shell start
```

### Bash (Linux default)

**Method 1: Source directly**

Add to your `~/.bashrc`:

```bash
# Claude worktree completions
source /path/to/repo/completions.bash
```

Reload:
```bash
source ~/.bashrc
```

**Method 2: System-wide installation**

```bash
# Install for all users (requires sudo)
sudo cp completions.bash /etc/bash_completion.d/cft-cftr

# Reload (or restart terminal)
source /etc/bash_completion.d/cft-cftr
```

**Method 3: User-specific installation**

```bash
# Create directory
mkdir -p ~/.bash_completion.d

# Copy completion
cp completions.bash ~/.bash_completion.d/cft-cftr

# Add to ~/.bashrc (if not already there)
if [ -f ~/.bash_completion.d/cft-cftr ]; then
    source ~/.bash_completion.d/cft-cftr
fi

# Reload
source ~/.bashrc
```

## Usage

### With cft

Type `cft` and press **Tab**:

```bash
$ cft <TAB>
main              # Existing branches
feature-auth
bugfix-memory
# ... your branches ...
```

Start typing to filter:

```bash
$ cft feat<TAB>
feature-auth
feature-payments
feature-dashboard
```

### With cftr

Type `cftr` and press **Tab**:

```bash
$ cftr <TAB>
feature-auth      # Active worktrees only
bugfix-memory
```

The completion for `cftr` only suggests branches that have active worktrees, making it safer and more convenient.

## Testing

Test if completion is working:

```bash
# Zsh
which _cft
# Should output: _cft () { ... }

# Bash  
complete -p cft
# Should output: complete -F _cft_completion cft

# Try it
cd /path/to/git/repo
cft <TAB><TAB>
# Should show branch names
```

## How It Works

### cft completion

1. Detects if you're in a git repository
2. Lists all git branches
3. Filters out current branch, main, and master
4. Suggests branches as you type
5. Allows custom branch names (not just existing ones)

### cftr completion

1. Detects if you're in a git repository
2. Gets the project name from repo root
3. Scans parent directory for `<project>-<branch>` worktrees
4. Suggests only branches with active worktrees
5. Helps prevent errors (can't remove non-existent worktrees)

## Troubleshooting

### Completion not working in Zsh

```bash
# Check if completion system is initialized
echo $fpath
# Should include completion directories

# Reinitialize
autoload -Uz compinit && compinit -i

# Check completion function
which _cft
```

### Completion not working in Bash

```bash
# Check if bash-completion is installed
dpkg -l | grep bash-completion  # Debian/Ubuntu
rpm -qa | grep bash-completion  # RedHat/Fedora

# Install if missing
sudo apt-get install bash-completion  # Debian/Ubuntu
sudo yum install bash-completion      # RedHat/Fedora

# Check if sourced
complete -p | grep cft
```

### Completion shows wrong results

```bash
# Clear completion cache (Zsh)
rm ~/.zcompdump*
compinit

# Reload shell configuration
source ~/.zshrc  # or ~/.bashrc
```

### Completion is slow

The completion scripts are optimized, but in repos with thousands of branches, it might be slow. To improve:

```bash
# Limit branch suggestions (edit completion file)
# Change: git branch --format='%(refname:short)'
# To:     git branch --format='%(refname:short)' | head -50
```

## Advanced Configuration

### Custom branch filtering (Zsh)

Edit `completions.zsh` to customize which branches appear:

```bash
# Only show branches starting with "feature/"
branches=(${(f)"$(git branch --format='%(refname:short)' | grep '^feature/')"})

# Exclude archived branches
branches=(${(f)"$(git branch --format='%(refname:short)' | grep -v 'archived')"})
```

### Custom worktree location (both)

If your worktrees aren't at `../<project>-<branch>`, modify the completion:

```bash
# Change this line:
local parent_dir=$(dirname "$project_dir")

# To your custom location:
local parent_dir="$HOME/worktrees"
```

## Uninstalling

### Zsh

```bash
# If sourced in ~/.zshrc
# Remove the 'source' line from ~/.zshrc

# If in completions directory
rm ~/.zsh/completions/_cft_cftr

# If Oh My Zsh plugin
rm ~/.oh-my-zsh/custom/plugins/cft-cftr.plugin.zsh

# Reload
source ~/.zshrc
```

### Bash

```bash
# If sourced in ~/.bashrc
# Remove the 'source' line from ~/.bashrc

# If system-wide
sudo rm /etc/bash_completion.d/cft-cftr

# If user-specific
rm ~/.bash_completion.d/cft-cftr

# Reload
source ~/.bashrc
```

## Benefits

✅ **Faster workflow** - type less, do more  
✅ **Fewer typos** - select from list instead of typing  
✅ **Discover branches** - see what branches exist  
✅ **Safety** - cftr only shows removable worktrees  
✅ **Productivity** - spend less time typing branch names

## Examples

```bash
# Quick feature creation
$ cft fea<TAB>        # Expands to feature-
$ cft feature-<TAB>   # Shows: feature-auth, feature-payments, etc.

# Quick cleanup
$ cftr <TAB>          # Shows only active worktrees
$ cftr bug<TAB>       # Filters to: bugfix-memory, bugfix-leak

# Discover what's active
$ cftr <TAB><TAB>     # Lists all active worktrees
```

Enjoy faster development with shell completion! 🚀
