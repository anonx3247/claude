#!/bin/bash

# Prerequisites checker for cft/cftr scripts
# Verifies all required tools are installed and configured correctly

echo "======================================"
echo "Claude Worktree Scripts - Health Check"
echo "======================================"
echo ""

all_good=true

# Check 1: Git version
echo "Checking Git installation..."
if command -v git &> /dev/null; then
    git_version=$(git --version | grep -oE '[0-9]+\.[0-9]+' | head -1)
    git_major=$(echo $git_version | cut -d. -f1)
    git_minor=$(echo $git_version | cut -d. -f2)
    
    if [ "$git_major" -gt 2 ] || ([ "$git_major" -eq 2 ] && [ "$git_minor" -ge 5 ]); then
        echo "✓ Git version $git_version (worktree support available)"
    else
        echo "✗ Git version $git_version is too old (need 2.5+)"
        all_good=false
    fi
else
    echo "✗ Git not found"
    all_good=false
fi
echo ""

# Check 2: Claude CLI
echo "Checking Claude CLI..."
if command -v claude &> /dev/null; then
    echo "✓ Claude CLI found at: $(which claude)"
    
    # Try to check version
    if claude --version &> /dev/null; then
        echo "  Version: $(claude --version 2>&1 | head -1)"
    fi
else
    echo "✗ Claude CLI not found"
    echo "  Install from: https://docs.anthropic.com/claude/docs/cli"
    all_good=false
fi
echo ""

# Check 3: Text editor
echo "Checking text editor..."
if [ -n "$EDITOR" ]; then
    if command -v "$EDITOR" &> /dev/null; then
        echo "✓ Editor configured: $EDITOR (at $(which $EDITOR))"
    else
        echo "⚠ \$EDITOR is set to '$EDITOR' but command not found"
        echo "  Will try default editors (hx, vim, nano)"
    fi
else
    echo "ℹ \$EDITOR not set, will use default (hx)"
fi

# Check for common editors
editors_found=()
for editor in hx vim nano vi emacs code; do
    if command -v $editor &> /dev/null; then
        editors_found+=("$editor")
    fi
done

if [ ${#editors_found[@]} -gt 0 ]; then
    echo "  Available editors: ${editors_found[*]}"
else
    echo "✗ No common text editors found"
    all_good=false
fi
echo ""

# Check 4: Bash/Zsh
echo "Checking shell..."
current_shell=$(basename "$SHELL")
echo "  Current shell: $current_shell"

if [[ "$current_shell" == "bash" ]] || [[ "$current_shell" == "zsh" ]]; then
    echo "✓ Compatible shell detected"
else
    echo "⚠ Shell '$current_shell' may not be fully compatible"
    echo "  Scripts are tested with bash and zsh"
fi
echo ""

# Check 5: Scripts installed
echo "Checking cft/cftr installation..."
cft_found=false
cftr_found=false

if command -v cft &> /dev/null; then
    echo "✓ cft command available"
    cft_found=true
    echo "  Location: $(which cft 2>/dev/null || type cft)"
elif [ -f "./cft" ]; then
    echo "ℹ cft script found in current directory (not in PATH)"
    echo "  Run: cp cft ~/.local/bin/ && chmod +x ~/.local/bin/cft"
else
    echo "✗ cft not found"
fi

if command -v cftr &> /dev/null; then
    echo "✓ cftr command available"
    cftr_found=true
    echo "  Location: $(which cftr 2>/dev/null || type cftr)"
elif [ -f "./cftr" ]; then
    echo "ℹ cftr script found in current directory (not in PATH)"
    echo "  Run: cp cftr ~/.local/bin/ && chmod +x ~/.local/bin/cftr"
else
    echo "✗ cftr not found"
fi
echo ""

# Check 6: Template files
echo "Checking template files..."
if [ -f "./CLAUDE.md" ]; then
    echo "✓ CLAUDE.md template found"
else
    echo "⚠ CLAUDE.md template not found in current directory"
    echo "  Optional but recommended for project guidelines"
fi
echo ""

# Check 7: Git repository
echo "Checking if in a git repository..."
if git rev-parse --git-dir &> /dev/null; then
    echo "✓ Inside a git repository"
    repo_root=$(git rev-parse --show-toplevel)
    echo "  Repository root: $repo_root"
    
    # Check for worktrees
    worktree_count=$(git worktree list | wc -l)
    if [ "$worktree_count" -gt 1 ]; then
        echo "  Active worktrees: $((worktree_count - 1))"
    fi
else
    echo "ℹ Not in a git repository (normal if checking installation)"
fi
echo ""

# Check 8: Network connectivity (for git push/PR creation)
echo "Checking GitHub connectivity..."
if timeout 3 bash -c 'cat < /dev/null > /dev/tcp/github.com/443' 2>/dev/null; then
    echo "✓ Can reach GitHub"
else
    echo "⚠ Cannot reach GitHub (might be offline or firewall)"
fi
echo ""

# Summary
echo "======================================"
if $all_good; then
    echo "✓ All critical checks passed!"
    echo ""
    echo "You're ready to use cft and cftr!"
    echo ""
    echo "Quick start:"
    echo "  cft my-feature-branch"
    echo ""
else
    echo "⚠ Some issues found"
    echo ""
    echo "Please address the issues marked with ✗ above"
    echo ""
    echo "Common fixes:"
    echo "  - Install Git 2.5+: https://git-scm.com/"
    echo "  - Install Claude CLI: https://docs.anthropic.com/claude/docs/cli"
    echo "  - Install a text editor: brew install helix (or vim, nano)"
    echo "  - Install cft/cftr: cp cft cftr ~/.local/bin/"
    echo ""
fi
echo "======================================"
echo ""

if ! $all_good; then
    exit 1
fi
