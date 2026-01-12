# Claude Worktree Scripts (`cft` and `cftr`)

Shell scripts to automate setting up Claude sessions in git worktrees for autonomous feature development.

## Overview

These scripts extend your existing `ft` and `ftr` functions to work with Claude, automating the setup of isolated development environments where Claude can work on features autonomously.

**`cft`** (Claude Feature Tree) - Creates a git worktree and starts a Claude session
**`cftr`** (Claude Feature Tree Remove) - Cleans up the worktree and branch

## Features

- 🌳 Creates isolated git worktrees for feature development
- 📝 Interactive prompt creation with your preferred editor
- 📋 Generates task-specific instructions for Claude
- 🤖 **Automatically starts Claude** with all tools enabled
- 🎯 Aims to create a PR for your review
- 🔧 Creates helper script for restarting Claude sessions
- 🧹 Easy cleanup with `cftr`
- ✅ Comprehensive test suite included

## Installation

### 1. Copy scripts to your PATH

```bash
# Copy to a directory in your PATH (e.g., /usr/local/bin or ~/.local/bin)
sudo cp cft cftr /usr/local/bin/
# OR
cp cft cftr ~/.local/bin/

# Make sure they're executable
sudo chmod +x /usr/local/bin/cft /usr/local/bin/cftr
# OR
chmod +x ~/.local/bin/cft ~/.local/bin/cftr
```

### 2. Or source them in your shell config

Add to your `~/.zshrc`:

```bash
# Add the directory containing the scripts to PATH
export PATH="$PATH:/path/to/scripts"
```

### 3. Verify installation

```bash
which cft
which cftr
```

## Prerequisites

- **Git** with worktree support
- **Text editor** (hx, helix, nvim, vim, or nano)
- **Claude CLI** (optional but recommended) - For automatic Claude invocation

If Claude CLI is not installed, `cft` will still prepare the worktree and create a helper script you can run manually when Claude is available.

## Usage

### Creating a Claude Feature Session

```bash
# In your git repository
cft feature-name
```

This will:
1. Create a new branch named `feature-name` (if it doesn't exist)
2. Create a git worktree at `../<project>-feature-name/`
3. Open your editor to write instructions for Claude
4. Copy `CLAUDE.md` to the worktree (if it exists)
5. Create a `TASK.md` file with your instructions
6. Create a `run-claude.sh` helper script
7. **Automatically start Claude** with all tools enabled

### Writing the Prompt

When you run `cft`, your editor will open. Write clear instructions for Claude:

```markdown
Implement user authentication with the following requirements:
- Add login/logout endpoints
- Use JWT tokens for session management
- Add password hashing with bcrypt
- Write comprehensive tests
- Update documentation
```

**Tips:**
- Lines starting with `#` are treated as comments and removed
- If you leave the file empty, Claude will infer the task from the branch name
- Be specific about requirements and constraints
- Mention any existing patterns to follow

### What Claude Does

Once started, Claude will:
1. Read `TASK.md` and `CLAUDE.md` to understand the task
2. Explore the codebase to understand the context
3. Plan the implementation approach
4. Write tests following TDD practices
5. Implement the feature
6. Run linters and type checkers
7. Create a pull request for your review

### If Claude Isn't Found

If Claude CLI isn't installed or found in PATH, `cft` will:
- Still set up the worktree with all necessary files
- Display a helpful message with options
- Create `run-claude.sh` that you can use later

You can then:
1. Install Claude CLI and run `./run-claude.sh` in the worktree
2. Open the worktree in your preferred editor
3. Use a different Claude interface

### Restarting a Claude Session

If Claude's session ends or you want to restart it:

```bash
cd ../<project>-feature-name
./run-claude.sh
```

The `run-claude.sh` script:
- Shows the initial prompt used
- Detects the correct Claude CLI flags automatically
- Can be customized for your specific Claude setup

### Cleaning Up

When you're done (or want to start over):

```bash
cftr feature-name
```

This will:
1. Remove the worktree at `../<project>-feature-name/`
2. Delete the branch `feature-name`
3. Switch back to `main` if you were on the feature branch

## Example Workflow

```bash
# 1. Create a feature with Claude
$ cft add-user-auth

# Editor opens, you write:
# "Implement JWT-based authentication with login/logout endpoints"

# 2. Claude starts automatically and works on the task
# - Explores codebase
# - Plans implementation
# - Writes tests
# - Implements feature
# - Creates PR

# 3. Review the PR
# (on GitHub/GitLab/etc.)

# 4. If you need to restart Claude or make changes
$ cd ../myproject-add-user-auth
$ ./run-claude.sh

# 5. Clean up when done
$ cd ../myproject
$ cftr add-user-auth
```

## Integration with Existing Workflow

These scripts are designed to complement your existing `ft` and `ftr` functions:

- **`ft`**: For manual development in a worktree
- **`ftr`**: To clean up after manual development
- **`cft`**: For Claude-assisted development in a worktree
- **`cftr`**: To clean up after Claude development

All four can be used interchangeably on the same branches and worktrees.

## File Structure

When you run `cft feature-name`, the following structure is created:

```
parent-directory/
├── myproject/                 # Original repo
│   └── CLAUDE.md             # Your guidelines
└── myproject-feature-name/   # Worktree
    ├── CLAUDE.md             # Copy of guidelines
    ├── TASK.md               # Task-specific instructions
    ├── run-claude.sh         # Claude restart helper
    └── ...                   # All your project files
```

## Configuration

### Choosing Your Editor

The scripts try editors in this order:
1. `hx` (Helix)
2. `helix`
3. `nvim` (Neovim)
4. `vim`
5. `nano`

Set your preferred editor with the `EDITOR` environment variable:

```bash
export EDITOR=vim
```

### Customizing Claude Invocation

The script automatically detects the correct Claude CLI flags by checking `claude --help`. It tries:
1. `claude --allow-all-tools` (if supported)
2. `claude -allow all` (fallback)
3. `claude` (basic invocation)

You can customize `run-claude.sh` in each worktree for specific needs:

```bash
#!/bin/bash
# Example: Use specific Claude CLI options
claude --allow-all-tools \
  --model claude-3-opus \
  --max-tokens 4096
```

### Non-Interactive Mode (for Testing/Automation)

```bash
cft feature-name --non-interactive "Your task description here"
```

This skips the editor and uses the provided task description directly. Useful for:
- Automated testing
- CI/CD pipelines
- Scripting workflows

## Testing

The repository includes comprehensive tests:

### Basic Tests

```bash
./test-scripts.sh
```

Tests:
- Script existence and executability
- Usage message display
- Bash syntax validation
- Essential command presence

### Integration Tests

```bash
./integration-test.sh
```

Tests:
- Full workflow (create → verify → cleanup)
- Worktree and branch creation
- File generation (TASK.md, run-claude.sh, CLAUDE.md)
- Proper cleanup
- Non-interactive mode

## Troubleshooting

### "Branch already exists"

If the branch already exists, `cft` will use it. If you want a fresh start:

```bash
cftr feature-name  # Clean up existing
cft feature-name   # Create fresh
```

### "Worktree already exists"

Same as above - use `cftr` to clean up first.

### Editor doesn't open

Make sure one of the supported editors is installed, or set `EDITOR`:

```bash
export EDITOR=nano
cft feature-name
```

### Claude CLI not found

If you see "Warning: 'claude' command not found":

1. **Install Claude CLI** following your platform's instructions
2. **Verify installation**: `which claude`
3. **Manually run**: `cd ../project-feature && ./run-claude.sh`

The worktree is still set up correctly; you just need to start Claude manually.

### Git worktree errors

Make sure you're in a git repository:

```bash
git status
```

### Claude flags don't work

The script tries to auto-detect the correct flags. If that fails:

1. Check `claude --help` for supported flags
2. Edit `run-claude.sh` in your worktree
3. Update the Claude invocation manually

## Comparison with `ft` and `ftr`

| Feature | `ft` / `ftr` | `cft` / `cftr` |
|---------|--------------|----------------|
| Creates worktree | ✅ | ✅ |
| Creates branch | ✅ | ✅ |
| Opens editor | Zed editor | Prompt editor |
| Generates tasks | ❌ | ✅ (TASK.md) |
| Copies CLAUDE.md | ❌ | ✅ |
| Claude setup | ❌ | ✅ (automatic) |
| Helper scripts | ❌ | ✅ (run-claude.sh) |
| Test suite | ❌ | ✅ |
| Cleanup | ✅ | ✅ |

## Advanced Usage

### Combining with Other Tools

```bash
# Use with your existing aliases
cft my-feature
cd ../project-my-feature
# Claude works...
# After Claude creates commits:
gp  # Your alias for 'git push'
```

### Pre-commit Hooks

Add `cft` to your development workflow:

```bash
# .git/hooks/pre-push
#!/bin/bash
# Automatically test before pushing
if [ -f "test-scripts.sh" ]; then
  ./test-scripts.sh
fi
```

### CI/CD Integration

```yaml
# .github/workflows/claude-test.yml
name: Test Claude Scripts
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: |
          ./test-scripts.sh
          ./integration-test.sh
```

## Contributing

Ideas for enhancements:

- Add support for different Claude CLI tools
- Integrate with CI/CD pipelines
- Add template support for different project types
- Create hooks for pre/post Claude sessions
- Add progress indicators for long-running tasks

## License

MIT License - Feel free to use and modify as needed.

## Credits

Built to extend the `ft`/`ftr` workflow pattern with AI-powered autonomous development.
