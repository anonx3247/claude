#!/bin/bash

# cftr - Claude Feature Task Remove
# Removes the git worktree and branch created by cft

set -e  # Exit on error

if [ -z "$1" ]; then
  echo "Usage: cftr <branch-name>"
  exit 1
fi

feature_name=$1

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: Not in a git repository"
  exit 1
fi

project_dir=$(git rev-parse --show-toplevel)
project=$(basename "$project_dir")
cd "$project_dir"
feature_path="../$project-$feature_name"

echo "Cleaning up Claude feature task: $feature_name"
echo ""

# Track if anything was cleaned up
cleaned_something=false

# Check if worktree exists, delete only if it does
if [ -d "$feature_path" ]; then
  echo "Removing worktree at: $feature_path"
  if git worktree remove "$feature_path" --force 2>/dev/null; then
    echo "✓ Worktree removed successfully"
    cleaned_something=true
  else
    # If worktree remove fails, try manual removal
    echo "Warning: git worktree remove failed, trying manual cleanup..."
    if git worktree prune 2>/dev/null; then
      echo "✓ Worktree pruned"
    fi
    if [ -d "$feature_path" ]; then
      echo "Warning: Worktree directory still exists at $feature_path"
      echo "You may need to remove it manually: rm -rf $feature_path"
    fi
  fi
else
  echo "Worktree not found at: $feature_path (already cleaned up)"
fi

echo ""

# Check if branch exists, delete only if it does
if git show-ref --verify --quiet refs/heads/$feature_name; then
  echo "Deleting branch: $feature_name"
  if git branch -D "$feature_name" 2>/dev/null; then
    echo "✓ Branch deleted successfully"
    cleaned_something=true
  else
    echo "Warning: Could not delete branch $feature_name"
    echo "It may be currently checked out or protected"
  fi
else
  echo "Branch not found: $feature_name (already deleted)"
fi

echo ""
if [ "$cleaned_something" = true ]; then
  echo "✓ Cleanup complete!"
else
  echo "Nothing to clean up (already removed)"
fi
