# Quick Start Guide

Get up and running with `cft` and `cftr` in 5 minutes.

## Installation (60 seconds)

```bash
# 1. Clone or download this repo
git clone <repo-url>
cd claude-worktree-scripts

# 2. Copy scripts
mkdir -p ~/.local/bin
cp cft cftr ~/.local/bin/
chmod +x ~/.local/bin/cft ~/.local/bin/cftr

# 3. Add to PATH (if needed)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# 4. Reload shell
source ~/.zshrc

# 5. Verify
cft
# Should show: "Usage: cft <branch-name>"
```

## Your First Claude Task (2 minutes)

```bash
# 1. Go to any git repository
cd ~/my-project

# 2. Start Claude on a task
cft test-claude

# 3. In the editor that opens, write:
Create a simple hello.sh script that prints "Hello, World!"

# 4. Save and close

# 5. Claude works autonomously and creates a PR

# 6. Check the result
cd ../my-project-test-claude
ls -la
cat hello.sh

# 7. Clean up
cd ~/my-project
cftr test-claude
```

Done! 🎉

## Common Commands

```bash
# Create feature with Claude
cft add-user-login
# Write instructions → Claude implements → Creates PR

# Clean up after merge
cftr add-user-login
# Removes worktree and branch

# Check prerequisites
./check_prereqs.sh
# Verifies git, claude, editor, etc.

# Run tests
./test_scripts.sh
# Validates scripts are working correctly
```

## Real-World Example

Let's add authentication to a web app:

```bash
# 1. Start the task
cft add-jwt-authentication

# 2. In editor, write:
Add JWT-based authentication:
- POST /api/auth/login endpoint
- POST /api/auth/register endpoint
- JWT token generation and validation
- Password hashing with bcrypt
- Authentication middleware
- Tests with 90%+ coverage

# 3. Save and close - Claude takes over!

# Claude will:
# ✓ Analyze your codebase
# ✓ Design the implementation
# ✓ Write the code
# ✓ Add comprehensive tests
# ✓ Create a pull request

# 4. Review the PR on GitHub

# 5. Merge if satisfied

# 6. Clean up
cftr add-jwt-authentication
```

## Directory Structure

After running `cft my-feature`:

```
my-project/                    # Original repo (unchanged)
├── .git/
├── src/
└── ...

my-project-my-feature/         # New worktree
├── .git -> ../my-project/.git # Links to main repo
├── CLAUDE.md                  # Guidelines for Claude
├── TASK.md                    # Your specific task
├── src/                       # Your feature code
└── ...
```

## Workflow Cheat Sheet

```bash
# Feature development
cft feature-name     # Start Claude
cftr feature-name    # Clean up

# Bug fixes
cft fix-bug-name     # Start Claude
cftr fix-bug-name    # Clean up

# Tests
cft add-tests        # Claude adds tests
cftr add-tests       # Clean up

# Documentation
cft add-docs         # Claude documents
cftr add-docs        # Clean up

# Let Claude infer the task
cft refactor-auth    # No instructions needed
                     # Claude figures it out!
```

## Integration with Your Workflow

These work alongside your existing tools:

```bash
# Your manual workflow
ft my-feature        # You code
ftr my-feature       # Clean up

# Claude automated workflow
cft add-tests        # Claude codes
cftr add-tests       # Clean up

# Both create worktrees at:
# ../project-branch-name
```

## Tips for Success

### ✅ Do

- **Write clear instructions** - Be specific about what you want
- **Start small** - Begin with simple tasks to learn
- **Review PRs** - Always review Claude's work before merging
- **Use CLAUDE.md** - Add project guidelines for consistency
- **Let Claude infer** - For obvious tasks, branch name is enough

### ❌ Don't

- **Don't skip reviews** - Always check Claude's code
- **Don't forget cleanup** - Run `cftr` when done
- **Don't assume perfection** - Claude makes mistakes, review carefully
- **Don't over-specify** - Trust Claude to make good decisions

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `cft: command not found` | Add ~/.local/bin to PATH |
| `claude: command not found` | Install Claude CLI |
| Editor doesn't open | Set `export EDITOR=vim` |
| Can't create worktree | Make sure you're in a git repo |
| Branch already exists | Use `cftr` to clean up first |

## Next Steps

1. **Read examples**: Check [EXAMPLES.md](EXAMPLES.md) for real-world scenarios
2. **Install completion**: See [COMPLETION.md](COMPLETION.md) for tab completion
3. **Check prerequisites**: Run `./check_prereqs.sh`
4. **Customize CLAUDE.md**: Add your project guidelines
5. **Try parallel work**: Use `ft` and `cft` together

## Quick Reference

```bash
cft <branch>         # Create worktree, start Claude
cftr <branch>        # Remove worktree, delete branch
./check_prereqs.sh   # Verify installation
./test_scripts.sh    # Test scripts
```

## Support

- **Full documentation**: [README.md](README.md)
- **Examples**: [EXAMPLES.md](EXAMPLES.md)
- **Installation**: [INSTALL.md](INSTALL.md)
- **Completion**: [COMPLETION.md](COMPLETION.md)

---

**Time to first feature: < 5 minutes** ⚡  
**Lines of code needed: 1 command** 📝  
**Joy of autonomous coding: Priceless** 😊

Happy coding with Claude! 🚀
