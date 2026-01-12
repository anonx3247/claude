# Claude Git Worktree Tools (cft & cftr)

Shell scripts for integrating Claude AI with git worktrees to enable autonomous feature development.

## Overview

These tools allow you to:
- Create isolated git worktrees for feature branches
- Give Claude AI clear task instructions
- Let Claude autonomously develop features and create PRs
- Easily clean up when done

**`cft`** (Claude Feature Tool) - Creates worktree + starts Claude session  
**`cftr`** (Claude Feature Tool Remove) - Cleans up worktree and branch

## Quick Start

```bash
# Install
git clone <this-repo>
cd <this-repo>
cp cft cftr ~/.local/bin/  # Or add to PATH

# Use
cft add-user-authentication
# (editor opens for instructions)
# Claude works autonomously in new worktree

# When done
cftr add-user-authentication
```

## Installation

### Option 1: Add to PATH (Recommended)

```bash
# Copy to a directory in your PATH
cp cft cftr ~/.local/bin/
chmod +x ~/.local/bin/cft ~/.local/bin/cftr

# Or create symlinks
ln -s $(pwd)/cft ~/.local/bin/cft
ln -s $(pwd)/cftr ~/.local/bin/cftr
```

### Option 2: Source in .zshrc or .bashrc

```bash
# Add to ~/.zshrc or ~/.bashrc
export PATH="$PATH:/path/to/this/repo"

# Or source directly
source /path/to/this/repo/cft
source /path/to/this/repo/cftr
```

### Prerequisites

- Git 2.5+ (with worktree support)
- Bash 4.0+
- Text editor (defaults to `hx`, configurable via `$EDITOR`)
- Claude CLI (optional but recommended)

## Usage

### cft - Create Claude Worktree

```bash
cft <branch-name>
```

**What it does:**

1. Creates a new git branch (if doesn't exist)
2. Creates a git worktree in parallel directory: `../<project>-<branch-name>`
3. Opens your editor to write task instructions
4. Copies `CLAUDE.md` to worktree (if exists)
5. Creates `TASK.md` with your instructions
6. Offers to start Claude session with all tools enabled

**Example:**

```bash
cft add-user-authentication
```

This creates:
- Branch: `add-user-authentication`
- Worktree: `../myproject-add-user-authentication/`
- Task file: `../myproject-add-user-authentication/TASK.md`

### Editor Prompt

When `cft` opens your editor, you'll see a template:

```markdown
# Claude Task Instructions for: add-user-authentication

## Task Description
Write your specific task instructions below.

## Your Instructions

[Write your instructions here]

## Examples of good instructions:
- "Add JWT-based authentication with bcrypt password hashing"
- "Fix memory leak in image processing pipeline"
- "Refactor API client to use async/await with retry logic"
```

**Tips for good instructions:**
- Be specific about requirements and constraints
- Mention libraries or patterns to use
- Include testing requirements
- Reference existing code to follow

**If you leave it empty**, Claude will infer the task from the branch name.

### cftr - Remove Claude Worktree

```bash
cftr <branch-name>
```

**What it does:**

1. Warns if worktree has uncommitted changes
2. Removes the git worktree
3. Asks if you want to delete the branch
   - If merged: defaults to YES
   - If unmerged: shows commits and defaults to NO
4. Cleans up temporary files

**Example:**

```bash
cftr add-user-authentication
```

**Interactive Prompts:**

For unmerged branches:
```
⚠ Branch has NOT been merged into main.
  This branch may contain work you want to keep.
  abc123 Add authentication endpoints
  def456 Add JWT token generation
  ...
  
Delete the branch anyway? (y/N):
```

For merged branches:
```
Branch has been merged into main.
Delete the branch? (Y/n):
```

## Workflow Examples

### Simple Feature

```bash
# Start new feature
cft implement-search

# Editor opens - write instructions:
# "Add full-text search using the existing search library"

# Claude starts working in ../myproject-implement-search/
# Claude explores, plans, implements, tests, creates PR

# Review Claude's work
cd ../myproject-implement-search
git log
git diff main

# If good, merge
git checkout main
git merge implement-search
git push

# Clean up
cftr implement-search
```

### Bug Fix

```bash
# Start bug fix
cft fix/memory-leak-in-parser

# Leave instructions empty - let Claude infer from branch name

# Claude investigates and fixes the issue

# Review and test
cd ../myproject-fix-memory-leak-in-parser
npm test
npm run lint

# Merge if satisfied
git checkout main
git merge fix/memory-leak-in-parser

# Clean up
cftr fix/memory-leak-in-parser
```

### Complex Refactoring

```bash
# Start refactoring
cft refactor/api-client

# Detailed instructions in editor:
# "Refactor the API client to:
# - Use async/await instead of promises
# - Add retry logic with exponential backoff
# - Improve error handling with custom error types
# - Add comprehensive tests
# - Keep backward compatibility"

# Claude works autonomously

# Review carefully before merging
cd ../myproject-refactor-api-client
git log --patch
npm test -- --coverage

# Merge after thorough review
git checkout main
git merge refactor/api-client

# Clean up
cftr refactor/api-client
```

## File Structure

After running `cft my-feature`, you'll have:

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
  ├── .run-claude.sh            # Helper script to start Claude
  ├── src/
  └── ...
```

### Generated Files

#### TASK.md

Contains your task instructions and workflow guidelines:

```markdown
# Task: my-feature

## Objective
Create a pull request to implement this feature.

## Task Description
[Your custom instructions or inferred from branch name]

## Workflow Guidelines
1. Explore - Read codebase to understand context
2. Plan - Design approach before implementing
3. Implement - Write code following TDD
4. Test - Ensure comprehensive coverage
5. Document - Add clear comments
6. Create PR - Push and create pull request

## Development Standards
- Follow CLAUDE.md conventions
- Write tests first (TDD)
- Keep code simple and maintainable
...
```

#### .run-claude.sh

Helper script to start Claude with proper context:

```bash
#!/bin/bash
# Starts Claude with TASK.md and CLAUDE.md as context
# Automatically detects correct Claude CLI flags

./run-claude.sh
```

## Configuration

### Editor

Set your preferred editor with the `EDITOR` environment variable:

```bash
export EDITOR=nvim     # Use Neovim
export EDITOR=vim      # Use Vim
export EDITOR=code -w  # Use VS Code (wait for close)
export EDITOR=nano     # Use Nano
```

Default is `hx` (Helix).

Add to `~/.zshrc` or `~/.bashrc` to persist.

### Claude CLI

The scripts work with the `claude` CLI and automatically detect the correct flags:
- `--allow-all-tools` (standard)
- `-allow all` (alternative)

If Claude CLI is not found, the scripts will:
1. Create the worktree and task files
2. Show instructions for manual Claude invocation
3. Provide a helper script (`.run-claude.sh`) to run later

## Comparison with ft/ftr

These tools follow the same pattern as `ft` (feature task) and `ftr` but add Claude AI integration:

| Feature | ft/ftr | cft/cftr |
|---------|--------|----------|
| Create branch | ✓ | ✓ |
| Create worktree | ✓ | ✓ |
| Open editor | Zed | Configurable (`$EDITOR`) |
| Task instructions | ✗ | ✓ Interactive prompt |
| Copy CLAUDE.md | ✗ | ✓ Automatic |
| Create TASK.md | ✗ | ✓ Generated |
| Start Claude | ✗ | ✓ Optional |
| Warn on uncommitted changes | ✗ | ✓ |
| Smart branch deletion | Basic | ✓ Merged vs unmerged |
| Show commits before delete | ✗ | ✓ |

## Advanced Usage

### Non-interactive Mode

For scripting or CI/CD:

```bash
# Set instructions via heredoc
echo "Add user authentication with JWT" | cft add-auth

# Or pre-create task file
mkdir -p /tmp/claude-prompt-add-auth-$$.md
echo "Task instructions here" > /tmp/claude-prompt-add-auth-$$.md
cft add-auth
```

### Multiple Features in Parallel

```bash
# Start multiple features
cft feature-a
cft feature-b
cft feature-c

# Work on them in parallel
cd ../myproject-feature-a  # Terminal 1
cd ../myproject-feature-b  # Terminal 2
cd ../myproject-feature-c  # Terminal 3

# Clean up when done
cftr feature-a
cftr feature-b
cftr feature-c
```

### Resuming Work

If Claude session is interrupted:

```bash
# Navigate to worktree
cd ../myproject-my-feature

# Review what was done
git log
git status

# Resume Claude session
./.run-claude.sh

# Or manually
claude --allow-all-tools
# Tell Claude: "Continue working on TASK.md. Review what's been done so far."
```

## Troubleshooting

### "claude: command not found"

The Claude CLI is not installed or not in PATH.

**Solutions:**
1. Install Claude CLI and add to PATH
2. Use the worktree manually with your preferred editor
3. The `.run-claude.sh` script will show the error and instructions

### "Not in a git repository"

You're not inside a git repository.

**Solution:**
```bash
cd /path/to/your/git/repo
cft my-feature
```

### "Worktree already exists"

The worktree directory already exists from a previous `cft` call.

**Solutions:**
```bash
# Option 1: Remove and recreate
cftr my-feature
cft my-feature

# Option 2: Use existing worktree
cd ../myproject-my-feature

# Option 3: Use different branch name
cft my-feature-v2
```

### "Permission denied"

Scripts are not executable.

**Solution:**
```bash
chmod +x cft cftr
```

### Branch name with special characters

Use quotes:

```bash
cft "feature/add-auth"
cft "fix/bug-#123"
```

## Best Practices

### Branch Naming

Use descriptive names that help Claude understand the task:

✓ Good:
- `add-user-authentication`
- `fix-memory-leak-in-parser`
- `refactor-api-client-async`
- `feature/search-integration`

✗ Bad:
- `feature1`
- `test`
- `wip`
- `asdfgh`

### Writing Instructions

Be specific and include context:

✓ Good:
```markdown
Add user authentication:
- Use JWT tokens (library: jsonwebtoken)
- Hash passwords with bcrypt (12 rounds)
- Create login and signup endpoints
- Add authentication middleware
- Store users in existing PostgreSQL database
- Write integration tests
- Follow existing API patterns in src/api/
```

✗ Bad:
```markdown
Add auth
```

### Code Review

Always review Claude's work before merging:

```bash
cd ../myproject-my-feature

# Check commits
git log --patch

# Run tests
npm test  # or pytest, cargo test, etc.

# Check code quality
npm run lint
npm run typecheck

# Review changes
git diff main...HEAD
```

### Incremental Development

For large features, break into smaller tasks:

```bash
cft auth-backend
# Claude implements backend

cft auth-frontend
# Claude implements frontend

cft auth-integration-tests
# Claude adds integration tests
```

## Tips & Tricks

### 1. Use CLAUDE.md

Create a `CLAUDE.md` in your repository root with:
- Project structure explanation
- Coding standards
- Patterns to follow
- Testing requirements
- Common gotchas

`cft` will automatically copy it to the worktree.

### 2. Branch from Feature Branches

```bash
# Create feature
cft add-auth

# Later, branch from it
cd ../myproject-add-auth
git checkout -b add-auth-frontend
git worktree add ../myproject-add-auth-frontend add-auth-frontend

# Or use cft again (it will use existing branch if exists)
```

### 3. Preserve Work in Progress

```bash
# Before cleaning up, push to remote
cd ../myproject-my-feature
git push -u origin my-feature

# Now you can clean up local worktree
cftr my-feature  # Keep branch

# Later, recreate worktree
cft my-feature  # Will use existing branch
```

### 4. Review Before Starting Claude

```bash
cft my-feature
# Write instructions
# When asked "Start Claude now?", say No

cd ../myproject-my-feature
# Review TASK.md, edit if needed
vim TASK.md

# Start Claude when ready
./.run-claude.sh
```

## Security Considerations

⚠️ **Important**: Claude has full tool access (`--allow-all-tools`)

This means Claude can:
- Read and write any file in the worktree
- Run shell commands
- Make git commits and push
- Install packages

**Recommendations:**
1. Review `TASK.md` before starting Claude
2. Use worktrees (isolation from main working directory)
3. Review all changes before merging
4. Don't use on repositories with sensitive data unless you trust Claude completely
5. Consider using `--allow` with specific tools for sensitive projects

## Contributing

Improvements welcome! Consider:
- Additional Claude CLI support
- Better error handling
- More editor support
- Integration with other tools
- Windows/PowerShell support

## License

MIT License - Use freely

## Related Tools

- `ft/ftr` - The inspiration (simpler worktree tools without AI)
- `git worktree` - Git's native worktree functionality
- Claude CLI - Claude AI command-line interface

---

**Happy coding with Claude! 🚀**
