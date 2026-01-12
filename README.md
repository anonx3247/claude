# Claude Worktree Scripts (`cft` and `cftr`)

Shell scripts to automate setting up Claude sessions in git worktrees for autonomous feature development.

## Overview

These scripts extend your existing `ft` and `ftr` functions to work with Claude, automating the setup of isolated development environments where Claude can work on features autonomously.

**`cft`** (Claude Feature Tree) - Creates a git worktree and prepares a Claude session
**`cftr`** (Claude Feature Tree Remove) - Cleans up the worktree and branch

## Features

- 🌳 Creates isolated git worktrees for feature development
- 📝 Interactive prompt creation with your preferred editor
- 📋 Generates task-specific instructions for Claude
- 🤖 Sets up Claude to work autonomously with all tools enabled
- 🎯 Aims to create a PR for your review
- 🧹 Easy cleanup with `cftr`

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
6. Set up a `run-claude.sh` script to start the Claude session

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

### Starting the Claude Session

```bash
cd ../<project>-feature-name
cat TASK.md              # Review the task
./run-claude.sh          # Start Claude
```

**Note:** The actual Claude invocation depends on your Claude CLI setup. You may need to modify `run-claude.sh` to match your environment.

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

# 2. Navigate to the worktree
$ cd ../myproject-add-user-auth

# 3. Review the task
$ cat TASK.md

# 4. Start Claude session
$ ./run-claude.sh
# (or your actual Claude CLI command)

# 5. Claude works autonomously:
#    - Explores codebase
#    - Plans implementation
#    - Writes tests
#    - Implements feature
#    - Creates PR

# 6. Review the PR
# (on GitHub/GitLab/etc.)

# 7. Clean up
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
    ├── run-claude.sh         # Claude launcher script
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

Edit the `run-claude.sh` file that gets created in each worktree to customize how Claude is invoked:

```bash
#!/bin/bash
# Example: Use your actual Claude CLI
claude-cli run \
  --allow-all-tools \
  --context="$(cat CLAUDE.md TASK.md)" \
  --objective="Create a PR for this feature"
```

## Requirements

- Git (with worktree support)
- A text editor (hx, nvim, vim, or nano)
- Claude CLI (for actually running Claude)

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

### Git worktree errors

Make sure you're in a git repository:

```bash
git status
```

## Comparison with `ft` and `ftr`

| Feature | `ft` / `ftr` | `cft` / `cftr` |
|---------|--------------|----------------|
| Creates worktree | ✅ | ✅ |
| Creates branch | ✅ | ✅ |
| Opens editor | Zed editor | Prompt editor |
| Generates tasks | ❌ | ✅ (TASK.md) |
| Copies CLAUDE.md | ❌ | ✅ |
| Claude setup | ❌ | ✅ (run-claude.sh) |
| Cleanup | ✅ | ✅ |

## Contributing

Feel free to customize these scripts for your workflow. Some ideas:

- Add support for different Claude CLI tools
- Integrate with your CI/CD pipeline
- Add template support for different project types
- Create hooks for pre/post Claude sessions

## License

MIT License - Feel free to use and modify as needed.
