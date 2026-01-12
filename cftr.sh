#!/bin/bash

# cftr - Claude Feature Task Remove
# Removes the git worktree and branch created by cft
# Based on the ftr (feature task remove) function pattern

set -e

if [ -z "$1" ]; then
  echo "Usage: cftr <branch-name>"
  echo ""
  echo "Removes the git worktree and branch created by cft."
  exit 1
fi

feature_name=$1

# Validate we're in a git repository
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

# Track what we cleaned
cleaned_worktree=false
cleaned_branch=false

# Check if worktree exists, delete only if it does
if [ -d "$feature_path" ]; then
  echo "Removing worktree: $feature_path"
  
  # Try to remove with git worktree remove
  if git worktree remove "$feature_path" --force 2>/dev/null; then
    echo "✓ Worktree removed"
    cleaned_worktree=true
  else
    echo "⚠ Could not remove worktree with git command"
    
    # Prune stale worktrees
    git worktree prune 2>/dev/null || true
    
    # Check if directory still exists
    if [ -d "$feature_path" ]; then
      echo "⚠ Worktree directory still exists: $feature_path"
      echo "  You may need to manually remove it:"
      echo "  rm -rf $feature_path"
    else
      echo "✓ Worktree cleaned up"
      cleaned_worktree=true
    fi
  fi
else
  echo "Worktree not found (already removed or never created)"
fi

echo ""

# Check if branch exists, delete only if it does
if git show-ref --verify --quiet refs/heads/"$feature_name"; then
  echo "Deleting branch: $feature_name"
  
  # Check if we're currently on that branch
  current_branch=$(git branch --show-current)
  if [ "$current_branch" = "$feature_name" ]; then
    echo "⚠ Currently on branch $feature_name, switching to main first"
    git checkout main 2>/dev/null || git checkout master 2>/dev/null || {
      echo "Error: Could not switch away from $feature_name"
      echo "Please checkout a different branch first"
      exit 1
    }
  fi
  
  if git branch -D "$feature_name" 2>/dev/null; then
    echo "✓ Branch deleted"
    cleaned_branch=true
  else
    echo "⚠ Could not delete branch $feature_name"
    echo "  It may be protected or have unmerged changes"
  fi
else
  echo "Branch not found (already deleted or never created)"
fi

echo ""
echo "=========================================="
if [ "$cleaned_worktree" = true ] || [ "$cleaned_branch" = true ]; then
  echo "Cleanup complete!"
  [ "$cleaned_worktree" = true ] && echo "  ✓ Worktree removed"
  [ "$cleaned_branch" = true ] && echo "  ✓ Branch deleted"
else
  echo "Nothing to clean up"
fi
echo "=========================================="
