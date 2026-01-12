# Claude Git Worktree Tools

Two shell scripts to integrate Claude AI with git worktrees for automated development.

## Overview

- **`cft`** (Claude Feature Tool) - Creates a git worktree with Claude integration
- **`cftr`** (Claude Feature Tool Remove) - Cleans up worktrees and branches created by `cft`

These tools follow the same pattern as the existing `ft` and `ftr` functions but add Claude AI automation capabilities.

## Installation

### Option 1: Add to PATH

```bash
# Copy scripts to a directory in your PATH
cp cft cftr ~/.local/bin/

# Or create symlinks
ln -s $(pwd)/cft ~/.local/bin/cft
ln -s $(pwd)/cftr ~/.local/bin/cftr
```

### Option 2: Add as zsh functions

Add to your `~/.zshrc`:

```bash
# Source the scripts or copy their content as functions
source /path/to/repo/cft
source /path/to/repo/cftr
```

## Usage

### cft - Create Claude Worktree

Creates a new git branch and worktree, prompts for task instructions, and starts a Claude session.

```bash
cft <branch-name>
```

**Example:**
```bash
cft add-user-authentication
```

**What it does:**

1. Creates a new branch (if it doesn't exist)
2. Creates a git worktree in parallel directory: `../<project>-<branch-name>`
3. Opens your editor (defaults to `hx`, configurable via `$EDITOR`) for task instructions
4. Copies `CLAUDE.md` to the worktree (if it exists)
5. Creates `TASK.md` with your instructions
6. Starts Claude with `--allow-all-tools` and context from `TASK.md` and `CLAUDE.md`

**Instructions Prompt:**

When the editor opens, you can provide specific instructions for Claude. For example:

```markdown
# Claude Instructions for: add-user-authentication

## Task Description
# Write your instructions below. If left empty, Claude will infer the task from the branch name.

## Instructions

Implement user authentication with the following requirements:
- Support email/password login
- Add JWT token generation
- Include password hashing with bcrypt
- Create login and signup endpoints
- Add authentication middleware
- Write comprehensive tests
```

If you leave it empty, Claude will infer the task from the branch name.

### cftr - Remove Claude Worktree

Removes the worktree and optionally deletes the branch.

```bash
cftr <branch-name>
```

**Example:**
```bash
cftr add-user-authentication
```

**What it does:**

1. Removes the git worktree at `../<project>-<branch-name>`
2. Prompts if you want to delete the branch
3. If branch has unmerged changes, asks for confirmation
4. Cleans up temporary files

**Interactive Prompts:**

```
Do you want to delete the branch? (y/N):
```

If the branch has unmerged changes:
```
Branch has unmerged changes.
Force delete anyway? (y/N):
```

## Workflow Example

### Starting a new feature with Claude:

```bash
# Create worktree with Claude
cft implement-search-feature

# Editor opens - add your instructions or leave empty
# Claude starts working in the worktree
# Claude explores, plans, implements, and creates a PR

# Review the PR Claude created
cd ../myproject-implement-search-feature
git log
git diff main

# If satisfied, merge the branch
git checkout main
git merge implement-search-feature
git push

# Clean up
cftr implement-search-feature
```

## How It Works

### Directory Structure

```
myproject/               # Main project directory
  ├── .git/
  ├── CLAUDE.md         # Development guidelines
  ├── src/
  └── ...

myproject-feature-x/    # Worktree created by cft
  ├── .git -> ../myproject/.git/worktrees/feature-x
  ├── CLAUDE.md         # Copied from main project
  ├── TASK.md           # Task-specific instructions
  ├── src/
  └── ...
```

### Files Created

#### TASK.md

Generated in the worktree with your instructions:

```markdown
# Task: feature-name

## Objective
Create a pull request to solve the following task.

## Instructions
[Your custom instructions here]

## Workflow
1. Explore the repository and understand the codebase
2. Plan your approach
3. Implement the solution following TDD practices
4. Run tests and ensure everything passes
5. Push your branch and create a pull request

## Guidelines
- Follow the conventions in CLAUDE.md
- Write tests before implementation
- Keep code simple and maintainable
- Run linters and type checkers
- Aim for 80%+ code coverage
```

### Claude Integration

The scripts expect the `claude` CLI to be available in your PATH. Claude is invoked with:

```bash
claude --allow-all-tools --context TASK.md --context CLAUDE.md
```

This gives Claude:
- Access to all tools (file operations, git, terminal, etc.)
- Context from your task instructions
- Context from project guidelines

## Configuration

### Editor

Set your preferred editor with the `EDITOR` environment variable:

```bash
export EDITOR=nvim  # or vim, nano, code, etc.
```

Default is `hx` (Helix).

### Claude CLI

Ensure the `claude` CLI is installed and in your PATH. If not found, the script will create the worktree and display instructions for manual Claude invocation.

## Comparison with ft/ftr

| Feature | ft/ftr | cft/cftr |
|---------|--------|----------|
| Create branch | ✓ | ✓ |
| Create worktree | ✓ | ✓ |
| Open editor | Zed | User configurable |
| Task instructions | ✗ | ✓ (optional) |
| Copy CLAUDE.md | ✗ | ✓ |
| Create TASK.md | ✗ | ✓ |
| Start Claude | ✗ | ✓ |
| Interactive cleanup | Basic | Advanced |

## Requirements

- Git with worktree support (Git 2.5+)
- Bash
- Text editor (defaults to `hx`)
- Claude CLI (optional but recommended)

## Troubleshooting

### "claude: command not found"

The `claude` CLI is not in your PATH. The script will still create the worktree and task files. You can:

1. Install the Claude CLI and add it to PATH
2. Manually start Claude in the worktree directory
3. Use the worktree with your preferred editor

### Permission denied

Make sure the scripts are executable:

```bash
chmod +x cft cftr
```

### Worktree already exists

If you see "Worktree already exists", either:

1. Use a different branch name
2. Remove the existing worktree first: `cftr <branch-name>`
3. Work in the existing worktree directly

## Tips

1. **Branch naming**: Use descriptive names that help Claude understand the task:
   - ✓ `add-user-authentication`
   - ✓ `fix-memory-leak-in-parser`
   - ✗ `feature1`
   - ✗ `test`

2. **Instructions**: Be specific in your instructions for better results:
   - Include requirements, constraints, and acceptance criteria
   - Reference specific files or patterns to follow
   - Mention testing requirements

3. **Review before merging**: Always review Claude's work before merging:
   - Check the code quality
   - Run tests
   - Review the PR description

4. **Iterative development**: You can run `cft` multiple times on the same branch to continue work

## License

These scripts are provided as-is for use with Claude AI and git worktrees.
