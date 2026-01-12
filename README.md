# Claude Worktree Scripts (`cft` and `cftr`)

Shell scripts to integrate Claude AI into your git workflow using worktrees, following the same pattern as your existing `ft` and `ftr` functions.

## Overview

These scripts automate the process of:
1. Creating isolated git worktrees for feature development
2. Setting up Claude AI to work autonomously on tasks
3. Having Claude create pull requests for review
4. Cleaning up worktrees and branches when done

## Scripts

### `cft` - Claude Feature Task

Creates a git worktree and launches Claude AI to work on a feature branch autonomously.

**Usage:**
```bash
./cft.sh <branch-name>
```

**What it does:**
1. Creates a new branch (if it doesn't exist)
2. Creates a git worktree at `../<project>-<branch-name>`
3. Opens your editor to write task instructions
4. Copies the comprehensive `CLAUDE.md` template to the worktree
5. Creates `PROJECT_TASK.md` with specific task details
6. Launches Claude with all tools enabled (`-allow all`)
7. Claude explores, plans, implements, tests, and creates a PR

**Example:**
```bash
./cft.sh add-user-authentication
# Opens editor for task details
# Claude implements authentication
# Creates a PR when complete
```

### `cftr` - Claude Feature Task Remove

Cleans up the worktree and branch created by `cft`.

**Usage:**
```bash
./cftr.sh <branch-name>
```

**What it does:**
1. Removes the git worktree at `../<project>-<branch-name>`
2. Deletes the git branch
3. Cleans up all associated files

**Example:**
```bash
./cftr.sh add-user-authentication
# Removes worktree and branch
```

## Installation

### Method 1: Shell Functions (Recommended)

Add these functions to your `~/.zshrc` to use them like your existing `ft` and `ftr`:

```bash
cft() {
  /path/to/cft.sh "$1"
}

cftr() {
  /path/to/cftr.sh "$1"
}
```

Or, if you clone this repo to a known location:

```bash
# Add to ~/.zshrc
export CLAUDE_SCRIPTS_PATH="$HOME/path/to/this/repo"

cft() {
  "$CLAUDE_SCRIPTS_PATH/cft.sh" "$1"
}

cftr() {
  "$CLAUDE_SCRIPTS_PATH/cftr.sh" "$1"
}
```

Then reload your shell:
```bash
source ~/.zshrc
```

### Method 2: Add to PATH

```bash
# Copy scripts to a directory in your PATH
sudo cp cft.sh /usr/local/bin/cft
sudo cp cftr.sh /usr/local/bin/cftr
sudo chmod +x /usr/local/bin/cft /usr/local/bin/cftr
```

### Method 3: Symlink

```bash
# Create symlinks from a directory in your PATH
ln -s "$(pwd)/cft.sh" /usr/local/bin/cft
ln -s "$(pwd)/cftr.sh" /usr/local/bin/cftr
chmod +x cft.sh cftr.sh
```

## Requirements

- **Git** with worktree support (Git 2.5+)
- **Claude CLI** installed and configured (`claude` command available)
- **Text editor** - defaults to `hx` (Helix), configurable via `$EDITOR`
- **Bash or Zsh** shell

## Configuration

### Editor

Set your preferred editor:

```bash
export EDITOR=vim      # Use Vim
export EDITOR=nano     # Use Nano  
export EDITOR=hx       # Use Helix (default)
```

Add to your `~/.zshrc` to persist.

### Claude CLI

Ensure the `claude` command is installed and in your PATH:

```bash
which claude  # Should return the path to claude
```

## Workflow Examples

### Example 1: Feature Development

```bash
# Start Claude on a new feature
cft add-dark-mode

# In editor, provide instructions:
# "Add dark mode toggle in header. Use CSS variables for theming.
#  Persist preference in localStorage. Add tests."

# Claude will:
# - Explore codebase
# - Plan implementation  
# - Add dark mode CSS
# - Implement toggle
# - Add localStorage persistence
# - Write tests
# - Create PR

# Review PR on GitHub

# Clean up when done
cftr add-dark-mode
```

### Example 2: Bug Fix

```bash
# Start Claude on bug fix
cft fix-memory-leak

# Describe the bug:
# "Memory leak in Gallery component. Event listeners not cleaned up.
#  Fix and add proper cleanup in useEffect."

# Claude fixes the issue and creates PR

# Clean up
cftr fix-memory-leak
```

### Example 3: Infer from Branch Name

```bash
# Let Claude figure it out from the branch name
cft refactor-user-service

# In editor, just save without adding anything
# Claude will analyze the branch name and determine what to do

# Clean up
cftr refactor-user-service
```

### Example 4: Mixed Workflow

```bash
# You work on main feature manually
ft implement-payment-system
# ... code manually

# Have Claude work on tests in parallel
cft add-payment-tests
# Claude creates comprehensive tests

# Review both, merge, clean up
ftr implement-payment-system
cftr add-payment-tests
```

## How It Works

### File Structure

When you run `cft add-feature`:

```
project/                        # Original repo
├── .git/
├── CLAUDE.md                   # Comprehensive guidelines
└── (your files)

project-add-feature/            # Worktree created by cft
├── .git -> ../project/.git     # Linked to main repo
├── CLAUDE.md                   # Copied from main repo
├── PROJECT_TASK.md             # Specific task instructions
└── (your files)                # Branch-specific files
```

### Claude Process

1. **Read PROJECT_TASK.md** - Understands the specific task
2. **Read CLAUDE.md** - Learns project guidelines and best practices
3. **Explore** - Examines the codebase structure
4. **Plan** - Creates implementation strategy
5. **Implement** - Writes code following guidelines
6. **Test** - Ensures comprehensive test coverage
7. **Validate** - Runs linters, type checkers
8. **Commit** - Makes clear, atomic commits
9. **PR** - Creates detailed pull request

### CLAUDE.md Template

The comprehensive `CLAUDE.md` template provides Claude with:
- Code quality standards
- Testing requirements (TDD, 80%+ coverage)
- Language-specific guidelines (Python, TypeScript, etc.)
- OOP vs Functional programming preferences
- Database best practices
- Comment and documentation guidelines
- Development workflow

This ensures consistency across all Claude-generated code.

## Integration with Existing Tools

Your workflow aliases work seamlessly:

```bash
# Existing manual worktree functions
ft <branch>    # You code manually
ftr <branch>   # Clean up manual worktree

# New Claude worktree functions  
cft <branch>   # Claude codes autonomously
cftr <branch>  # Clean up Claude worktree

# Both use the same pattern:
# ../project-branch-name
```

## Troubleshooting

### Claude command not found

Check if Claude is installed and add to PATH if needed.

### Editor does not open

Set EDITOR environment variable explicitly in your shell config.

### Permission denied

Make scripts executable with `chmod +x cft.sh cftr.sh`

### Worktree already exists

Clean up first with `cftr <branch-name>` or manually remove.

### Git ownership issues

Add safe directory: `git config --global --add safe.directory /path/to/repo`

## Key Features

### This Implementation vs Others

1. **Uses PROJECT_TASK.md**: Separates task-specific instructions from general guidelines
2. **Copies CLAUDE.md**: Uses the existing comprehensive template
3. **Explicit -allow all**: Properly implements the required flag for Claude CLI
4. **Better prompting**: Provides Claude with structured instructions
5. **Clearer separation**: CLAUDE.md for guidelines, PROJECT_TASK.md for task

## Files

- `cft.sh` - Main script to create Claude worktree session
- `cftr.sh` - Cleanup script to remove worktree and branch
- `README.md` - This documentation
- `CLAUDE.md` - Comprehensive development guidelines (already in repo)

## License

MIT
