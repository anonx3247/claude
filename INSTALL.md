# Installation Guide for cft and cftr

This guide covers multiple installation methods for the `cft` and `cftr` scripts.

## Prerequisites

- **Git** 2.5+ (with worktree support)
- **Bash** or **Zsh** shell
- **Text editor** (hx, helix, nvim, vim, vi, or nano)
- **Claude CLI** (optional but recommended for automatic invocation)

To check your prerequisites:
```bash
git --version          # Should be 2.5 or higher
echo $SHELL            # Should be bash or zsh
which hx nvim vim      # Check available editors
which claude           # Check if Claude CLI is installed
```

## Installation Methods

### Method 1: Add to PATH (Recommended)

Copy scripts to a directory in your PATH:

```bash
# For user-only installation
mkdir -p ~/.local/bin
cp cft cftr ~/.local/bin/
chmod +x ~/.local/bin/cft ~/.local/bin/cftr

# For system-wide installation (requires sudo)
sudo cp cft cftr /usr/local/bin/
sudo chmod +x /usr/local/bin/cft /usr/local/bin/cftr
```

Verify installation:
```bash
which cft cftr
cft --help
```

### Method 2: Shell Functions (Alternative)

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
# Claude Feature Tree functions
export CFT_PATH="/path/to/repo"  # Update this path

cft() {
  "$CFT_PATH/cft" "$@"
}

cftr() {
  "$CFT_PATH/cftr" "$@"
}
```

Then reload your shell:
```bash
source ~/.zshrc  # or ~/.bashrc
```

### Method 3: Symlink

Create symbolic links in your PATH:

```bash
ln -s "$(pwd)/cft" ~/.local/bin/cft
ln -s "$(pwd)/cftr" ~/.local/bin/cftr
```

## Shell Completions (Optional)

### Bash Completions

Add to your `~/.bashrc`:

```bash
# cft/cftr completions
if [ -f "/path/to/completions.bash" ]; then
    source "/path/to/completions.bash"
fi
```

Or copy to the bash completions directory:
```bash
sudo cp completions.bash /etc/bash_completion.d/cft-cftr
```

### Zsh Completions

For Oh My Zsh:
```bash
mkdir -p ~/.oh-my-zsh/custom/plugins/cft-cftr
cp completions.zsh ~/.oh-my-zsh/custom/plugins/cft-cftr/_cft
```

For manual setup, add to `~/.zshrc`:
```bash
# Add completion directory to fpath
fpath=(~/.zsh/completions $fpath)

# Create completions directory if it doesn't exist
mkdir -p ~/.zsh/completions

# Copy completion file
cp completions.zsh ~/.zsh/completions/_cft

# Initialize completions
autoload -Uz compinit && compinit
```

## Configuration

### Setting Your Preferred Editor

By default, `cft` tries editors in this order: `$EDITOR`, `hx`, `helix`, `nvim`, `vim`, `vi`, `nano`.

To set your preferred editor:

```bash
# In ~/.zshrc or ~/.bashrc
export EDITOR=nvim  # or vim, hx, etc.
```

### Claude CLI Setup

If you have Claude CLI installed, `cft` will automatically invoke it. If not, you'll see helpful instructions.

To install Claude CLI, follow the instructions at: [Claude CLI Documentation]

## Verification

Test your installation:

```bash
# Check scripts are found
which cft cftr

# Check usage messages
cft
cftr

# Test in a git repository
cd /path/to/git/repo
cft test-feature --non-interactive "Test task"
cftr test-feature
```

## Troubleshooting

### "command not found: cft"

- Verify the script is in your PATH: `echo $PATH`
- Check script is executable: `ls -l $(which cft)`
- Reload shell: `source ~/.zshrc` or open new terminal

### "Not in a git repository"

- Run `cft` from within a git repository
- Initialize git if needed: `git init`

### "No suitable editor found"

- Install an editor: `brew install helix` or `apt install vim`
- Or set EDITOR: `export EDITOR=nano`

### "Claude CLI not found"

- `cft` will still work, creating all necessary files
- You can start Claude manually in the worktree
- Or install Claude CLI for automatic invocation

### Completions not working

**Bash:**
- Ensure bash-completion is installed
- Source your `.bashrc` again
- Try: `complete -p cft`

**Zsh:**
- Run `compinit` to rebuild completion cache
- Check fpath: `echo $fpath`
- Try: `which _cft`

## Uninstallation

To remove `cft` and `cftr`:

```bash
# If installed in ~/.local/bin
rm ~/.local/bin/cft ~/.local/bin/cftr

# If installed system-wide
sudo rm /usr/local/bin/cft /usr/local/bin/cftr

# Remove shell functions from ~/.zshrc or ~/.bashrc
# (edit and remove the cft/cftr function definitions)

# Remove completions
rm ~/.bash_completion.d/cft-cftr  # Bash
rm ~/.zsh/completions/_cft        # Zsh
```

## Next Steps

After installation, see:
- `README.md` - Usage examples and workflows
- `cft --help` - Command usage
- `cftr --help` - Cleanup usage

Start using it:
```bash
cd your-project
cft add-awesome-feature
# Write your task in the editor
# Claude will work autonomously and create a PR
```
