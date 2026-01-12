# Installation Guide for cft and cftr

Quick start guide to install and use the Claude worktree scripts.

## Quick Install (Recommended)

### For zsh users (macOS default):

```bash
# 1. Create local bin directory
mkdir -p ~/.local/bin

# 2. Download and install scripts
# (Replace with your actual repository path)
cd /path/to/this/repo
cp cft cftr ~/.local/bin/
chmod +x ~/.local/bin/cft ~/.local/bin/cftr

# 3. Add to PATH if not already there
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# 4. Add convenience functions to ~/.zshrc
cat >> ~/.zshrc << 'ZSHRC_EOF'

# Claude worktree functions
cft() {
  ~/.local/bin/cft "$1"
}

cftr() {
  ~/.local/bin/cftr "$1"
}
ZSHRC_EOF

# 5. Reload shell configuration
source ~/.zshrc

# 6. Verify installation
which cft cftr
```

### For bash users (Linux):

```bash
# 1. Create local bin directory
mkdir -p ~/.local/bin

# 2. Download and install scripts
cd /path/to/this/repo
cp cft cftr ~/.local/bin/
chmod +x ~/.local/bin/cft ~/.local/bin/cftr

# 3. Add to PATH if not already there
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# 4. Add convenience functions to ~/.bashrc
cat >> ~/.bashrc << 'BASHRC_EOF'

# Claude worktree functions
cft() {
  ~/.local/bin/cft "$1"
}

cftr() {
  ~/.local/bin/cftr "$1"
}
BASHRC_EOF

# 5. Reload shell configuration
source ~/.bashrc

# 6. Verify installation
which cft cftr
```

## Prerequisites

Before installing, ensure you have:

1. **Git** (version 2.5 or higher)
   ```bash
   git --version  # Should be 2.5+
   ```

2. **Claude CLI** installed
   ```bash
   which claude  # Should return a path
   ```
   
   If not installed, follow [Claude CLI installation guide](https://docs.anthropic.com/claude/docs/cli)

3. **Text editor** - One of these:
   - Helix (`hx`) - default
   - Vim (`vim`)
   - Nano (`nano`)
   - Any other editor
   
   Set your preference:
   ```bash
   export EDITOR=vim  # or hx, nano, etc.
   ```

## Verify Installation

After installation, run these commands to verify:

```bash
# Check commands are available
type cft
# Should output: cft is a shell function

type cftr
# Should output: cftr is a shell function

# Check scripts are executable
ls -l ~/.local/bin/cft ~/.local/bin/cftr
# Both should have 'x' permission

# Test help messages
cft
# Should show usage: "Usage: cft <branch-name>"

cftr
# Should show usage: "Usage: cftr <branch-name>"
```

## First Run

Try it out on a test repository:

```bash
# 1. Go to any git repository
cd ~/my-project

# 2. Start Claude on a test task
cft test-claude-integration

# 3. In the editor that opens, write:
#    "Create a simple hello.sh script that prints 'Hello, World!'"

# 4. Save and close the editor

# 5. Claude will work autonomously

# 6. When done, check the PR created by Claude

# 7. Clean up
cftr test-claude-integration
# Answer 'Y' to delete branch when prompted
```

## Copy CLAUDE.md Template

For best results, add the CLAUDE.md template to your repositories:

```bash
# Copy CLAUDE.md to your project
cd ~/my-project
cp /path/to/this/repo/CLAUDE.md .

# Edit it to match your project
vim CLAUDE.md

# Commit it
git add CLAUDE.md
git commit -m "Add Claude AI guidelines"
git push
```

The CLAUDE.md file provides Claude with:
- Project-specific coding standards
- Testing requirements
- Language preferences
- Development workflow

## Troubleshooting

### "command not found: cft"

Your PATH may not include ~/.local/bin. Add it:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc  # or ~/.bashrc
source ~/.zshrc  # or ~/.bashrc
```

### "command not found: claude"

Install the Claude CLI or ensure it's in your PATH.

### Editor doesn't open

Set EDITOR environment variable:

```bash
export EDITOR=vim  # or your preferred editor
echo 'export EDITOR=vim' >> ~/.zshrc  # Make it permanent
```

### Permission denied

Make scripts executable:

```bash
chmod +x ~/.local/bin/cft ~/.local/bin/cftr
```

### Git repository error

Make sure you're in a git repository:

```bash
git rev-parse --git-dir  # Should not error
```

## Updating Scripts

To update to newer versions:

```bash
# Pull latest changes
cd /path/to/this/repo
git pull

# Copy updated scripts
cp cft cftr ~/.local/bin/
chmod +x ~/.local/bin/cft ~/.local/bin/cftr

# Reload shell
source ~/.zshrc  # or ~/.bashrc
```

## Uninstalling

To remove the scripts:

```bash
# Remove scripts
rm ~/.local/bin/cft ~/.local/bin/cftr

# Remove functions from shell config
# Edit ~/.zshrc or ~/.bashrc and delete the cft/cftr function definitions

# Reload shell
source ~/.zshrc  # or ~/.bashrc
```

## Advanced: System-Wide Installation

To make available for all users (requires sudo):

```bash
# Copy to system bin
sudo cp cft cftr /usr/local/bin/
sudo chmod +x /usr/local/bin/cft /usr/local/bin/cftr

# Now all users can run cft/cftr directly
cft test-branch
```

## Integration with Existing Workflow

The scripts work alongside your existing git workflow:

```bash
# Your manual workflow (ft/ftr)
ft my-feature          # You code manually
ftr my-feature         # Clean up

# Claude automated workflow (cft/cftr)
cft add-tests          # Claude codes autonomously
cftr add-tests         # Clean up

# Mixed workflow
ft main-feature        # You do main work
cft add-tests          # Claude adds tests in parallel
```

Both create worktrees at: `../<project>-<branch-name>`

## Next Steps

- Read the [README.md](README.md) for detailed usage examples
- Check out [CLAUDE.md](CLAUDE.md) to customize for your projects
- Run [test_scripts.sh](test_scripts.sh) to validate installation

## Getting Help

If you encounter issues:

1. Check this installation guide
2. Read the troubleshooting section in [README.md](README.md)
3. Verify all prerequisites are met
4. Test with a simple repository first

Happy coding with Claude! 🚀
