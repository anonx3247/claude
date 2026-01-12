#!/bin/bash

# cft - Claude Feature Task
# Creates a git worktree and starts a Claude session to work on a feature branch

if [ -z "$1" ]; then
  echo "Usage: cft <branch-name>"
  exit 1
fi

feature_name=$1

# Check if branch exists, create only if it doesn't
if ! git show-ref --verify --quiet refs/heads/$feature_name; then
  git branch $feature_name
fi

project_dir=$(git rev-parse --show-toplevel)
project=$(basename $project_dir)
cd $project_dir
feature_path="../$project-$feature_name"

# Check if worktree exists, create only if it doesn't
if [ ! -d "$feature_path" ]; then
  git worktree add $feature_path $feature_name
fi

# Create a temporary file for the prompt
prompt_file=$(mktemp)

# Open editor for user to write prompt (using hx - helix editor)
# If EDITOR env var is set, use that, otherwise default to hx
editor=${EDITOR:-hx}

# Create a template prompt file
cat > $prompt_file << 'PROMPT_EOF'
# Claude Task Instructions
# 
# Branch: BRANCH_NAME_PLACEHOLDER
#
# Write your instructions below. If you leave this file empty or delete these
# comments, Claude will determine what to do based on the branch name.
#
# Delete these comment lines and write your specific instructions:

PROMPT_EOF

# Replace placeholder in the template
sed -i "s/BRANCH_NAME_PLACEHOLDER/$feature_name/g" $prompt_file

# Open the editor
$editor $prompt_file

# Read the prompt (remove comment lines)
prompt=$(grep -v '^#' $prompt_file | grep -v '^\s*$' | tr '\n' ' ')
rm $prompt_file

# If prompt is empty, use branch name as context
if [ -z "$prompt" ]; then
  prompt="Work on the feature: $feature_name. Explore the codebase, understand what needs to be done based on the branch name, create a plan, and implement the solution. Create a PR when ready."
fi

# Create CLAUDE.md file in the worktree
cat > "$feature_path/CLAUDE.md" << 'CLAUDE_EOF'
# Claude AI Development Session

## Objective
Create a pull request for the feature/fix described below.

## Instructions
1. **Explore**: Understand the codebase and existing structure
2. **Plan**: Create a clear plan for implementing the feature
3. **Execute**: Implement the solution with proper testing
4. **Validate**: Ensure all tests pass and code quality is maintained
5. **Document**: Add necessary documentation and comments
6. **PR**: Create a pull request with clear description

## Tools Available
You have access to all tools including:
- File operations (read, write, edit)
- Command execution (run tests, lint, build)
- Git operations (commit, push, create PR)

## Task Description
CLAUDE_EOF

# Append the actual prompt to CLAUDE.md
echo "$prompt" >> "$feature_path/CLAUDE.md"

echo "Created worktree at: $feature_path"
echo "Created CLAUDE.md with instructions"
echo ""
echo "Starting Claude session..."
echo ""

# Change to the worktree directory and start Claude
cd $feature_path

# Run Claude with the instructions
# Using -allow-all-tools flag and reading from CLAUDE.md
claude -allow-all-tools "$(cat CLAUDE.md)"

echo ""
echo "Claude session completed."
echo "Worktree remains at: $feature_path"
