# Claude Worktree Scripts

Shell scripts to create and manage Claude AI development sessions in git worktrees.

## Overview

These scripts extend the existing `ft` and `ftr` functions to integrate Claude AI into your git workflow. They automate the process of creating isolated development environments (worktrees) where Claude can work on features autonomously.

## Scripts

### `cft` - Claude Feature Task

Creates a git worktree and starts a Claude AI session to work on a feature branch.

**Usage:**
```bash
./cft.sh <branch-name>
```

**What it does:**
1. Creates a new git branch (if it doesn't exist)
2. Creates a git worktree in `../<project>-<branch-name>`
3. Opens your editor (default: `hx`, configurable via `$EDITOR`) to write task instructions
4. If no instructions are provided, Claude will infer the task from the branch name
5. Creates a `CLAUDE.md` file in the worktree with the task description
6. Starts a Claude session with all tools enabled
7. Claude will explore, plan, implement, and create a PR

**Example:**
```bash
./cft.sh add-user-authentication
# Opens editor for you to describe the task
# Claude then works on implementing user authentication
# Creates a PR when done
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
# Removes worktree and deletes branch
```

## Installation

### Method 1: Add to PATH

```bash
# Copy scripts to a directory in your PATH
sudo cp cft.sh /usr/local/bin/cft
sudo cp cftr.sh /usr/local/bin/cftr
sudo chmod +x /usr/local/bin/cft /usr/local/bin/cftr
```

### Method 2: Add as shell functions

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
cft() {
  /path/to/cft.sh "$@"
}

cftr() {
  /path/to/cftr.sh "$@"
}
```

## Configuration

### Editor

By default, `cft` uses the `hx` (Helix) editor. You can change this by setting the `EDITOR` environment variable:

```bash
export EDITOR=vim
# or
export EDITOR=nano
# or
export EDITOR=code --wait
```

### Claude Command

The scripts assume `claude` command is available in your PATH. Make sure Claude CLI is properly installed and configured.

## Workflow Example

```bash
# Start a new feature with Claude
cft fix-login-bug
# -> Opens editor to describe the bug
# -> Claude analyzes code, creates fix, tests it
# -> Claude creates PR

# Review Claude's PR on GitHub/GitLab

# If satisfied, merge the PR

# Clean up the worktree
cftr fix-login-bug
```

## How It Works

### CLAUDE.md Template

The `cft` script creates a `CLAUDE.md` file in each worktree with structured instructions:

```markdown
# Claude AI Development Session

## Objective
Create a pull request for the feature/fix described below.

## Instructions
1. **Explore**: Understand the codebase and existing structure
2. **Plan**: Create a clear plan for implementing the feature
3. **Execute**: Implement the solution with proper testing
4. **Validate**: Ensure all tests pass and code quality is maintained
5. **Document**: Add necessary documentation and comments
6. **PR**: Create a pull request with clear description

## Tools Available
You have access to all tools including:
- File operations (read, write, edit)
- Command execution (run tests, lint, build)
- Git operations (commit, push, create PR)

## Task Description
[Your custom instructions go here]
```

### Integration with Existing Tools

These scripts work alongside your existing git aliases:

- `ft` / `ftr` - Manual worktrees (you code)
- `cft` / `cftr` - Claude worktrees (AI codes)

Both use the same worktree pattern: `../<project>-<branch-name>`

## Requirements

- Git (with worktree support)
- A text editor (hx, vim, nano, etc.)
- Claude CLI tool installed and configured
- Bash or Zsh shell

## Troubleshooting

### Editor doesn't open
- Check that your editor command is correct
- Try setting `EDITOR` environment variable explicitly

### Claude command not found
- Ensure Claude CLI is installed
- Check that `claude` is in your PATH: `which claude`

### Permission denied
- Make scripts executable: `chmod +x cft.sh cftr.sh`

### Worktree already exists
- The script will not recreate existing worktrees
- Use `cftr` to clean up first if you want to start fresh

## Advanced Usage

### Skip Editor Prompt

If you want to automate the process, you can modify the script to accept instructions via command line or from a file.

### Custom CLAUDE.md Templates

You can customize the `CLAUDE.md` template in the `cft` script to match your team's workflow.

### Integration with CI/CD

These scripts can be integrated into CI/CD pipelines to have Claude automatically work on branches triggered by specific events.

## License

MIT

## Contributing

Contributions welcome! Please submit PRs with improvements or bug fixes.
