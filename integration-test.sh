#!/bin/bash

# Integration test for cft and cftr

set -e

echo "Running integration test..."
echo "================================"

# Test feature name
TEST_FEATURE="test-feature-$(date +%s)"
TEST_PROMPT="Add a test feature with unit tests"

echo ""
echo "Test feature: $TEST_FEATURE"
echo "Test prompt: $TEST_PROMPT"
echo ""

# Test 1: Create a feature with cft
echo "Test 1: Creating feature with cft..."
./cft "$TEST_FEATURE" --non-interactive "$TEST_PROMPT"

# Test 2: Verify worktree exists
echo ""
echo "Test 2: Verifying worktree creation..."
project_name=$(basename $(git rev-parse --show-toplevel))
worktree_path="../$project_name-$TEST_FEATURE"

if [ -d "$worktree_path" ]; then
  echo "✓ Worktree exists at: $worktree_path"
else
  echo "✗ Worktree not found at: $worktree_path"
  exit 1
fi

# Test 3: Verify branch exists
echo ""
echo "Test 3: Verifying branch creation..."
if git show-ref --verify --quiet "refs/heads/$TEST_FEATURE"; then
  echo "✓ Branch exists: $TEST_FEATURE"
else
  echo "✗ Branch not found: $TEST_FEATURE"
  exit 1
fi

# Test 4: Verify TASK.md exists and contains prompt
echo ""
echo "Test 4: Verifying TASK.md..."
if [ -f "$worktree_path/TASK.md" ]; then
  if grep -q "$TEST_PROMPT" "$worktree_path/TASK.md"; then
    echo "✓ TASK.md exists and contains the prompt"
  else
    echo "✗ TASK.md doesn't contain the expected prompt"
    exit 1
  fi
else
  echo "✗ TASK.md not found"
  exit 1
fi

# Test 5: Verify run-claude.sh exists and is executable
echo ""
echo "Test 5: Verifying run-claude.sh..."
if [ -x "$worktree_path/run-claude.sh" ]; then
  echo "✓ run-claude.sh exists and is executable"
else
  echo "✗ run-claude.sh not found or not executable"
  exit 1
fi

# Test 6: Verify CLAUDE.md was copied
echo ""
echo "Test 6: Verifying CLAUDE.md copy..."
if [ -f "$worktree_path/CLAUDE.md" ]; then
  echo "✓ CLAUDE.md was copied to worktree"
else
  echo "✓ No CLAUDE.md to copy (this is OK)"
fi

# Test 7: Clean up with cftr
echo ""
echo "Test 7: Cleaning up with cftr..."
./cftr "$TEST_FEATURE"

# Test 8: Verify cleanup
echo ""
echo "Test 8: Verifying cleanup..."
cleanup_success=true

if [ -d "$worktree_path" ]; then
  echo "✗ Worktree still exists after cleanup"
  cleanup_success=false
fi

if git show-ref --verify --quiet "refs/heads/$TEST_FEATURE"; then
  echo "✗ Branch still exists after cleanup"
  cleanup_success=false
fi

if [ "$cleanup_success" = true ]; then
  echo "✓ Cleanup successful - worktree and branch removed"
else
  echo "✗ Cleanup failed"
  exit 1
fi

echo ""
echo "================================"
echo "All integration tests passed! ✓"
echo "================================"
