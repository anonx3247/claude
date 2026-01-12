# Installation Guide

## Quick Install for ~/.zshrc

Add these functions to your `~/.zshrc` file:

```bash
# Claude Feature Task functions
# Add these alongside your existing ft and ftr functions

cft() {
  local feature_name=$1
  local script_dir="$HOME/.local/bin"  # Or wherever you place the scripts
  
  if [ -z "$feature_name" ]; then
    echo "Usage: cft <branch-name>"
    return 1
  fi
  
  if [ ! -f "$script_dir/cft.sh" ]; then
    echo "Error: cft.sh not found at $script_dir/cft.sh"
    return 1
  fi
  
  bash "$script_dir/cft.sh" "$feature_name"
}

cftr() {
  local feature_name=$1
  local script_dir="$HOME/.local/bin"  # Or wherever you place the scripts
  
  if [ -z "$feature_name" ]; then
    echo "Usage: cftr <branch-name>"
    return 1
  fi
  
  if [ ! -f "$script_dir/cftr.sh" ]; then
    echo "Error: cftr.sh not found at $script_dir/cftr.sh"
    return 1
  fi
  
  bash "$script_dir/cftr.sh" "$feature_name"
}
```

## Installation Steps

### 1. Choose Installation Location

Create a directory for your scripts if it doesn't exist:

```bash
mkdir -p ~/.local/bin
```

### 2. Copy Scripts

```bash
# Copy the scripts to your chosen location
cp cft.sh ~/.local/bin/cft.sh
cp cftr.sh ~/.local/bin/cftr.sh

# Make them executable
chmod +x ~/.local/bin/cft.sh
chmod +x ~/.local/bin/cftr.sh
```

### 3. Add Functions to ~/.zshrc

```bash
# Open your ~/.zshrc file
vim ~/.zshrc
# or
code ~/.zshrc
# or
hx ~/.zshrc
```

Then add the functions shown above at the end of the file.

**Important:** Update the `script_dir` variable in the functions to match where you copied the scripts.

### 4. Reload Shell

```bash
source ~/.zshrc
```

### 5. Verify Installation

```bash
# Check that functions are available
type cft
type cftr

# Should output:
# cft is a shell function from ~/.zshrc
# cftr is a shell function from ~/.zshrc
```

## Alternative: Simpler Function Style

If you prefer simpler functions that directly call the scripts:

```bash
# Add to ~/.zshrc

# Claude worktree functions - simpler style
cft() {
  ~/.local/bin/cft.sh "$1"
}

cftr() {
  ~/.local/bin/cftr.sh "$1"
}
```

## Testing

Test your installation:

```bash
# In any git repository, try:
cft test-branch
# Should create branch and worktree, open editor

# Clean up:
cftr test-branch
# Should remove worktree and branch
```

## Troubleshooting Installation

### Function not found after sourcing

- Check that you saved ~/.zshrc correctly
- Verify syntax: `zsh -n ~/.zshrc`
- Try closing and reopening terminal

### Script not found errors

- Verify scripts are in the location specified by `script_dir`
- Check that paths are correct (no typos)
- Ensure scripts are executable: `ls -l ~/.local/bin/cft*.sh`

### Permission denied

```bash
chmod +x ~/.local/bin/cft.sh ~/.local/bin/cftr.sh
```

## Recommended Setup

Place the scripts in `~/.local/bin` and ensure this directory is in your PATH:

```bash
# Add to ~/.zshrc if not already present
export PATH="$HOME/.local/bin:$PATH"
```

Then the functions can be even simpler:

```bash
cft() {
  cft.sh "$1"
}

cftr() {
  cftr.sh "$1"
}
```

Or just skip the functions and use the scripts directly:

```bash
# If ~/.local/bin is in PATH, you can just run:
cft.sh my-branch
cftr.sh my-branch
```
