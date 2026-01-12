#!/bin/bash

# Test suite for cft and cftr scripts
# This doesn't run the full scripts (which would be interactive)
# but tests various helper functions and edge cases

set -e

echo "===================================="
echo "Testing cft and cftr scripts"
echo "===================================="
echo ""

# Test 1: Check scripts are executable
echo "Test 1: Checking executable permissions..."
if [ -x "./cft" ] && [ -x "./cftr" ]; then
    echo "✓ Both scripts are executable"
else
    echo "✗ Scripts missing execute permissions"
    exit 1
fi

# Test 2: Verify syntax
echo ""
echo "Test 2: Verifying bash syntax..."
if bash -n cft && bash -n cftr; then
    echo "✓ Both scripts have valid syntax"
else
    echo "✗ Syntax errors found"
    exit 1
fi

# Test 3: Check help messages
echo ""
echo "Test 3: Testing help/usage messages..."
if ./cft 2>&1 | grep -q "Usage:"; then
    echo "✓ cft shows usage when no arguments provided"
else
    echo "✗ cft missing usage message"
    exit 1
fi

if ./cftr 2>&1 | grep -q "Usage:"; then
    echo "✓ cftr shows usage when no arguments provided"
else
    echo "✗ cftr missing usage message"
    exit 1
fi

# Test 4: Check required tools mentions
echo ""
echo "Test 4: Checking script dependencies..."
if grep -q "git rev-parse" cft && grep -q "git rev-parse" cftr; then
    echo "✓ Both scripts check for git repository"
else
    echo "✗ Missing git repository checks"
    exit 1
fi

# Test 5: Verify CLAUDE.md template exists
echo ""
echo "Test 5: Verifying CLAUDE.md template..."
if [ -f "CLAUDE.md" ]; then
    echo "✓ CLAUDE.md template exists"
    if grep -q "Repository Information" CLAUDE.md; then
        echo "✓ CLAUDE.md has proper structure"
    else
        echo "✗ CLAUDE.md missing expected content"
        exit 1
    fi
else
    echo "✗ CLAUDE.md template not found"
    exit 1
fi

# Test 6: Check README documentation
echo ""
echo "Test 6: Verifying README documentation..."
if [ -f "README.md" ]; then
    echo "✓ README.md exists"
    if grep -q "cft" README.md && grep -q "cftr" README.md; then
        echo "✓ README documents both scripts"
    else
        echo "✗ README missing script documentation"
        exit 1
    fi
else
    echo "✗ README.md not found"
    exit 1
fi

# Test 7: Check for safety features in cftr
echo ""
echo "Test 7: Verifying safety features in cftr..."
if grep -q "Branch is merged" cftr && grep -q "Force delete" cftr; then
    echo "✓ cftr has interactive confirmation prompts"
else
    echo "✗ cftr missing safety confirmations"
    exit 1
fi

# Test 8: Verify error handling
echo ""
echo "Test 8: Checking error handling..."
if grep -q "set -e" cft && grep -q "set -e" cftr; then
    echo "✓ Both scripts use 'set -e' for error handling"
else
    echo "✗ Missing error handling"
    exit 1
fi

# Test 9: Check worktree path consistency
echo ""
echo "Test 9: Verifying worktree path patterns..."
if grep -q '../$project-$feature_name' cft && grep -q '../$project-$feature_name' cftr; then
    echo "✓ Both scripts use consistent worktree paths"
else
    echo "✗ Inconsistent worktree paths"
    exit 1
fi

# Test 10: Verify TASK.md generation
echo ""
echo "Test 10: Checking TASK.md generation..."
if grep -q "TASK.md" cft; then
    echo "✓ cft generates TASK.md for Claude"
else
    echo "✗ Missing TASK.md generation"
    exit 1
fi

echo ""
echo "===================================="
echo "All tests passed! ✓"
echo "===================================="
echo ""
echo "Note: This test suite validates structure and safety features."
echo "For full integration testing, manually run cft/cftr in a test repo."

