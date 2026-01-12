# Claude Git Worktree Tools (cft & cftr)

Shell scripts for integrating Claude AI with git worktrees to enable autonomous feature development.

## Overview

These tools allow you to:
- Create isolated git worktrees for feature branches
- Give Claude AI clear task instructions
- Let Claude autonomously develop features and create PRs
- Easily clean up when done

**`cft`** (Claude Feature Tool) - Creates worktree + optionally starts Claude  
**`cftr`** (Claude Feature Tool Remove) - Cleans up worktree and branch

## Quick Start

```bash
# Install
git clone <this-repo>
cd <this-repo>
cp cft cftr ~/.local/bin/

# Use
cft add-user-authentication
# (editor opens for instructions)
# Choose to start Claude now or later

# When done
cftr add-user-authentication
```

## Installation

### Option 1: Add to PATH (Recommended)

```bash
# Copy to a directory in your PATH
cp cft cftr ~/.local/bin/
chmod +x ~/.local/bin/cft ~/.local/bin/cftr
```

### Option 2: Source in .zshrc or .bashrc

```bash
# Add to ~/.zshrc or ~/.bashrc
export PATH="$PATH:/path/to/this/repo"
```

### Prerequisites

- Git 2.5+ (with worktree support)
- Bash 4.0+
- Text editor (defaults to `hx`, configurable via `$EDITOR`)
- Claude CLI (optional but recommended)

## Usage

### cft - Create Claude Worktree

```bash
cft <branch-name> [--non-interactive "prompt"]
```

**Interactive mode (default):**
```bash
cft add-user-authentication
# Opens editor for instructions
# Creates worktree and files
# Asks if you want to start Claude now
```

**Non-interactive mode (for scripting/testing):**
```bash
cft add-feature --non-interactive "Add search functionality"
# Skips editor, uses provided prompt
# Doesn't start Claude automatically
```

**What it does:**

1. Creates git branch (if doesn't exist)
2. Creates git worktree in `../<project>-<branch-name>`
3. Opens editor for task instructions (interactive mode only)
4. Copies `CLAUDE.md` to worktree
5. Creates `TASK.md` with instructions
6. Creates `.run-claude.sh` helper script
7. Optionally starts Claude session

### cftr - Remove Claude Worktree

```bash
cftr <branch-name> [--confirm]
```

**Default mode (non-interactive like ftr):**
```bash
cftr add-user-authentication
# Removes worktree
# Deletes branch (tries -d, then -D if needed)
# No confirmation prompts
```

**Confirm mode (interactive):**
```bash
cftr add-user-authentication --confirm
# Warns about uncommitted changes
# Shows commits for unmerged branches
# Asks for confirmation before deletion
```

**What it does:**

1. Removes git worktree
2. Switches away from branch if currently on it
3. Deletes branch (with --confirm: asks for confirmation)
4. Cleans up temporary files

## Workflow Examples

### Simple Feature

```bash
# Start new feature
cft implement-search
# Write instructions in editor
# Choose "Y" to start Claude now

# Claude works autonomously

# Later, review
cd ../myproject-implement-search
git log
git diff main

# Merge if satisfied
git checkout main
git merge implement-search

# Clean up
cftr implement-search
```

### Bug Fix with Non-Interactive Mode

```bash
# Create with preset instructions
cft fix-bug-123 --non-interactive "Fix memory leak in parser"

# Start Claude manually when ready
cd ../myproject-fix-bug-123
./.run-claude.sh

# Clean up with confirmation
cftr fix-bug-123 --confirm
```

### Quick Cleanup (No Confirmation)

```bash
# Multiple features
cft feature-a
cft feature-b
cft feature-c

# Quick cleanup (like ftr)
cftr feature-a
cftr feature-b
cftr feature-c
```

## File Structure

After running `cft my-feature`:

```
myproject/                        # Original repo
  ├── .git/
  ├── CLAUDE.md
  ├── src/
  └── ...

myproject-my-feature/            # New worktree
  ├── .git -> ../myproject/.git/worktrees/my-feature
  ├── CLAUDE.md                  # Copied from main repo
  ├── TASK.md                    # Generated task instructions
  ├── .run-claude.sh            # Helper to start/restart Claude
  ├── src/
  └── ...
```

### Generated Files

#### TASK.md

Your task instructions and workflow guidelines:

```markdown
# Task: my-feature

## Objective
Create a pull request to implement this feature.

## Task Description
[Your custom instructions]

## Workflow Guidelines
1. Explore - Understand codebase
2. Plan - Design approach
3. Implement - Write code with TDD
4. Test - Ensure coverage
5. Document - Add comments
6. Create PR - Push and create PR
```

#### .run-claude.sh

Helper script to start Claude:

```bash
#!/bin/bash
# Starts Claude with TASK.md and CLAUDE.md as context
# Auto-detects correct Claude CLI flags

./.run-claude.sh
```

## Configuration

### Editor

Set your preferred editor:

```bash
export EDITOR=nvim     # Neovim
export EDITOR=vim      # Vim
export EDITOR=code -w  # VS Code
export EDITOR=nano     # Nano
```

Default is `hx` (Helix). Falls back to: helix, nvim, vim, nano.

### Claude CLI

Works with `claude` CLI and auto-detects flags:
- `--allow-all-tools` (standard)
- `-allow all` (alternative)

If not found, creates files and shows manual invocation instructions.

## Comparison with ft/ftr

| Feature | ft/ftr | cft/cftr |
|---------|--------|----------|
| Create branch & worktree | ✓ | ✓ |
| Open editor | Zed | Configurable |
| Task instructions | ✗ | ✓ |
| Copy CLAUDE.md | ✗ | ✓ |
| Create TASK.md | ✗ | ✓ |
| Start Claude | ✗ | ✓ (optional) |
| Non-interactive mode | N/A | ✓ |
| Confirmation prompts | None | Optional (--confirm) |
| Helper script | ✗ | ✓ (.run-claude.sh) |

## Advanced Usage

### Parallel Features

```bash
# Work on multiple features simultaneously
cft feature-a
cft feature-b
cft feature-c

# Each in separate worktree
cd ../myproject-feature-a  # Terminal 1
cd ../myproject-feature-b  # Terminal 2
cd ../myproject-feature-c  # Terminal 3
```

### Resuming Claude Session

```bash
# If Claude session is interrupted
cd ../myproject-my-feature
./.run-claude.sh  # Restart Claude
```

### Scripting and Automation

```bash
# Create multiple features with preset tasks
features=("auth" "search" "profile")
for feat in "${features[@]}"; do
  cft "$feat" --non-interactive "Implement $feat feature"
done

# Batch cleanup
for feat in "${features[@]}"; do
  cftr "$feat"
done
```

## Troubleshooting

### "claude: command not found"

Claude CLI not installed or not in PATH.

**Solutions:**
- Install Claude CLI
- Use worktree manually with your editor
- `.run-claude.sh` will show instructions

### "Not in a git repository"

Run from within a git repository:

```bash
cd /path/to/your/git/repo
cft my-feature
```

### "Worktree already exists"

Worktree exists from previous run:

```bash
# Option 1: Remove and recreate
cftr my-feature
cft my-feature

# Option 2: Use existing
cd ../myproject-my-feature

# Option 3: Different branch name
cft my-feature-v2
```

### "Permission denied"

Make scripts executable:

```bash
chmod +x cft cftr
```

## Best Practices

### Branch Naming

Use descriptive names:

✓ Good:
- `add-user-authentication`
- `fix-memory-leak-in-parser`
- `refactor-api-client-async`

✗ Bad:
- `feature1`
- `test`
- `wip`

### Writing Instructions

Be specific:

✓ Good:
```
Add user authentication:
- Use JWT tokens (jsonwebtoken library)
- Hash passwords with bcrypt
- Create login/signup endpoints
- Add auth middleware
- Write integration tests
```

✗ Bad:
```
Add auth
```

### Code Review

Always review Claude's work:

```bash
cd ../myproject-my-feature
git log --patch
npm test
npm run lint
git diff main...HEAD
```

## Security Considerations

⚠️ **Claude has full tool access** (`--allow-all-tools`)

This means Claude can:
- Read/write files
- Run shell commands
- Make git commits
- Install packages

**Recommendations:**
- Review TASK.md before starting
- Use worktrees (isolation)
- Review all changes before merging
- Don't use on sensitive data without trust

## Tips

1. **Use CLAUDE.md**: Create project guidelines for Claude to follow
2. **Start small**: Test with simple features first
3. **Review everything**: Never merge without reviewing
4. **Keep branches focused**: One feature per branch
5. **Use --confirm when unsure**: Safer cleanup with confirmations

## License

MIT License

---

**Happy coding with Claude! 🚀**
