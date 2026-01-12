#!/bin/bash

# cftr - Claude Feature Task Remove
# Removes the git worktree and branch created by cft

if [ -z "$1" ]; then
  echo "Usage: cftr <branch-name>"
  exit 1
fi

feature_name=$1

project_dir=$(git rev-parse --show-toplevel)
project=$(basename $project_dir)
cd $project_dir
feature_path="../$project-$feature_name"

echo "Cleaning up Claude feature task: $feature_name"

# Check if worktree exists, delete only if it does
if [ -d "$feature_path" ]; then
  echo "Removing worktree at: $feature_path"
  git worktree remove $feature_path --force
else
  echo "Worktree not found at: $feature_path"
fi

# Check if branch exists, delete only if it does
if git show-ref --verify --quiet refs/heads/$feature_name; then
  echo "Deleting branch: $feature_name"
  git branch -D $feature_name
else
  echo "Branch not found: $feature_name"
fi

echo "Cleanup complete."
