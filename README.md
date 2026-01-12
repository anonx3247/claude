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
cft <branch-name>
```

**What it does:**
1. Creates a new branch (if it doesn't exist)
2. Creates a git worktree at `../<project>-<branch-name>`
3. Opens your editor to write task instructions
4. Copies the comprehensive `CLAUDE.md` template to the worktree
5. Creates `TASK.md` with specific task details
6. Launches Claude with all tools enabled
7. Claude explores, plans, implements, tests, and creates a PR

**Example:**
```bash
cft add-user-authentication
# Opens editor for task details
# Claude implements authentication
# Creates a PR when complete
```

### `cftr` - Claude Feature Task Remove

Cleans up the worktree and branch created by `cft` with interactive confirmations.

**Usage:**
```bash
cftr <branch-name>
```

**What it does:**
1. Removes the git worktree at `../<project>-<branch-name>`
2. Interactively asks whether to delete the branch
3. Checks if branch is merged before deletion
4. Requires confirmation for force-deletion of unmerged branches

**Example:**
```bash
cftr add-user-authentication
# Removes worktree
# Asks: "Branch is merged. Delete it? (Y/n):"
```

## Installation

### Method 1: Shell Functions (Recommended)

Add these functions to your `~/.zshrc` (or `~/.bashrc`) to use them like your existing `ft` and `ftr`:

```bash
# Claude worktree functions
cft() {
  ~/.local/bin/cft "$1"
}

cftr() {
  ~/.local/bin/cftr "$1"
}
```

First, copy the scripts to your local bin:

```bash
# Create directory if it doesn't exist
mkdir -p ~/.local/bin

# Copy scripts
cp cft ~/.local/bin/cft
cp cftr ~/.local/bin/cftr

# Make executable
chmod +x ~/.local/bin/cft ~/.local/bin/cftr

# Reload shell
source ~/.zshrc
```

### Method 2: Add to PATH

```bash
# Copy scripts to a directory in your PATH
sudo cp cft /usr/local/bin/cft
sudo cp cftr /usr/local/bin/cftr
sudo chmod +x /usr/local/bin/cft /usr/local/bin/cftr
```

### Method 3: Symlink

```bash
# Create symlinks from a directory in your PATH
ln -s "$(pwd)/cft" /usr/local/bin/cft
ln -s "$(pwd)/cftr" /usr/local/bin/cftr
chmod +x cft cftr
```

### Verify Installation

```bash
# Check that functions/commands are available
which cft   # Should show path to script
which cftr  # Should show path to script

# Or for functions:
type cft    # Should output: cft is a shell function
type cftr   # Should output: cftr is a shell function
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

The scripts support both `--allow-all-tools` and `-allow all` flag formats for compatibility.

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
# Prompts: "Branch is merged. Delete it? (Y/n):"
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
├── TASK.md                     # Specific task instructions
└── (your files)                # Branch-specific files
```

### Claude's Process

1. **Read TASK.md** - Understands the specific task
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

Check if Claude is installed and add to PATH if needed:
```bash
which claude
# If not found, install Claude CLI or add to PATH
```

### Editor does not open

Set EDITOR environment variable explicitly:
```bash
export EDITOR=vim
export EDITOR=hx
```

### Permission denied

Make scripts executable:
```bash
chmod +x cft cftr
```

### Worktree already exists

Clean up first:
```bash
cftr <branch-name>
# Or manually:
git worktree remove ../project-branch-name --force
git branch -D <branch-name>
```

### Git ownership issues

Add safe directory:
```bash
git config --global --add safe.directory /path/to/repo
```

### Branch deletion not working

The script will ask for confirmation:
- For merged branches: "Branch is merged. Delete it? (Y/n):"
- For unmerged: "Branch has unmerged changes. Force delete anyway? (y/N):"

Just answer appropriately for your situation.

## Key Features

### This Implementation

✅ **Follows ft/ftr pattern** - Same workflow as existing tools
✅ **No .sh extensions** - Clean command names
✅ **Interactive cleanup** - Safe branch deletion with confirmations
✅ **Editor flexibility** - Respects $EDITOR environment variable
✅ **Smart task inference** - Can infer from branch name if left empty
✅ **Comprehensive guidelines** - Uses existing CLAUDE.md template
✅ **Multiple CLI formats** - Supports both --allow-all-tools and -allow all
✅ **Proper error handling** - Clear messages and validation
✅ **Trap cleanup** - Ensures temp files are always cleaned up

## Advanced Tips

### Skip Interactive Prompts

For automation, you can modify cftr to skip prompts by setting an environment variable:

```bash
# Future enhancement - add to cftr:
if [ "$CLAUDE_AUTO_DELETE" = "1" ]; then
  # Skip prompts
fi
```

### Custom TASK.md Templates

Edit the TASK.md generation in `cft` to customize:
- Workflow steps
- Success criteria
- Project-specific instructions

### Parallel Development

Work on multiple features simultaneously:

```bash
cft feature-a    # Claude works on feature A
cft feature-b    # Claude works on feature B in parallel
ft my-feature    # You work on your feature manually

# Three parallel worktrees:
# ../project-feature-a
# ../project-feature-b  
# ../project-my-feature
```

## Files

- `cft` - Main script to create Claude worktree session
- `cftr` - Cleanup script to remove worktree and branch
- `README.md` - This comprehensive documentation
- `CLAUDE.md` - Development guidelines (already in repo)

## Contributing

Improvements welcome! Key areas:
- Support for different Claude CLI versions
- Better error handling for edge cases
- Integration with other editors
- Custom template support
- Non-interactive mode for CI/CD

## License

MIT

## Documentation Index

This repository includes comprehensive documentation:

- **[QUICK_START.md](QUICK_START.md)** - Get started in 5 minutes ⚡
- **[INSTALL.md](INSTALL.md)** - Detailed installation guide 📦
- **[EXAMPLES.md](EXAMPLES.md)** - Real-world usage scenarios 📚
- **[COMPLETION.md](COMPLETION.md)** - Shell completion setup 🎯
- **[CLAUDE.md](CLAUDE.md)** - AI development guidelines 🤖

## Validation and Testing

- **[check_prereqs.sh](check_prereqs.sh)** - Verify system requirements ✓
- **[test_scripts.sh](test_scripts.sh)** - Automated script testing 🧪

## Quick Links

| I want to... | Go to... |
|--------------|----------|
| Get started immediately | [QUICK_START.md](QUICK_START.md) |
| Install step-by-step | [INSTALL.md](INSTALL.md) |
| See usage examples | [EXAMPLES.md](EXAMPLES.md) |
| Enable tab completion | [COMPLETION.md](COMPLETION.md) |
| Check my setup | Run `./check_prereqs.sh` |
| Understand the code | Read this README |

## File Structure

```
.
├── cft                    # Main script - creates worktree + starts Claude
├── cftr                   # Cleanup script - removes worktree + branch
├── CLAUDE.md              # Template for AI development guidelines
├── README.md              # Comprehensive documentation (this file)
├── QUICK_START.md         # 5-minute getting started guide
├── INSTALL.md             # Detailed installation instructions
├── EXAMPLES.md            # Real-world usage examples
├── COMPLETION.md          # Shell completion setup guide
├── check_prereqs.sh       # Prerequisites verification script
├── test_scripts.sh        # Automated testing script
├── completions.zsh        # Zsh completion definitions
└── completions.bash       # Bash completion definitions
```

## Contributing

Found a bug? Have an improvement? Contributions welcome!

1. Fork the repository
2. Create a feature branch: `git checkout -b improve-feature`
3. Make your changes
4. Test thoroughly: `./test_scripts.sh`
5. Commit: `git commit -am 'Add improvement'`
6. Push: `git push origin improve-feature`
7. Create a Pull Request

## License

[Add your license here]

## Acknowledgments

- Inspired by the `ft`/`ftr` git worktree workflow
- Powered by Claude AI for autonomous development
- Built for developers who love automation

---

**Made with ❤️ for developers who want to code faster**
