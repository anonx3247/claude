#!/bin/bash

# cft - Claude Feature Task
# Creates a git worktree and starts a Claude session to work on a feature branch

set -e  # Exit on error

if [ -z "$1" ]; then
  echo "Usage: cft <branch-name>"
  exit 1
fi

feature_name=$1

# Validate branch name (basic check)
if [[ ! "$feature_name" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
  echo "Error: Invalid branch name. Use only letters, numbers, hyphens, underscores, and slashes."
  exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: Not in a git repository"
  exit 1
fi

# Check if branch exists, create only if it doesn't
if ! git show-ref --verify --quiet refs/heads/$feature_name; then
  echo "Creating branch: $feature_name"
  git branch $feature_name
else
  echo "Using existing branch: $feature_name"
fi

project_dir=$(git rev-parse --show-toplevel)
project=$(basename "$project_dir")
cd "$project_dir"
feature_path="../$project-$feature_name"

# Check if worktree exists, create only if it doesn't
if [ ! -d "$feature_path" ]; then
  echo "Creating worktree at: $feature_path"
  git worktree add "$feature_path" "$feature_name"
else
  echo "Using existing worktree at: $feature_path"
fi

# Create a temporary file for the prompt
prompt_file=$(mktemp)

# Open editor for user to write prompt (using hx - helix editor)
# If EDITOR env var is set, use that, otherwise default to hx
editor=${EDITOR:-hx}

# Create a template prompt file
cat > "$prompt_file" << 'PROMPT_EOF'
# Claude Task Instructions
# 
# Branch: 
#
# Write your instructions below. If you leave this file empty or delete these
# comments, Claude will determine what to do based on the branch name.
#
# Delete these comment lines and write your specific instructions:

PROMPT_EOF

# Insert branch name safely after "Branch: " line
# Using a more robust method that doesn't break with special characters
temp_file=$(mktemp)
awk -v branch="$feature_name" '/^# Branch: / {print $0 branch; next} {print}' "$prompt_file" > "$temp_file"
mv "$temp_file" "$prompt_file"

# Open the editor
echo "Opening editor for task instructions..."
if ! $editor "$prompt_file"; then
  echo "Warning: Editor exited with non-zero status"
fi

# Read the prompt (remove comment lines and empty lines)
prompt=$(grep -v '^#' "$prompt_file" | grep -v '^\s*$' | tr '\n' ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
rm "$prompt_file"

# If prompt is empty, use branch name as context
if [ -z "$prompt" ]; then
  echo "No specific instructions provided. Claude will infer task from branch name."
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

echo ""
echo "Created worktree at: $feature_path"
echo "Created CLAUDE.md with instructions"
echo ""

# Check if claude command exists
if ! command -v claude &> /dev/null; then
  echo "Warning: 'claude' command not found in PATH"
  echo "Please install Claude CLI or ensure it's in your PATH"
  echo "Worktree and CLAUDE.md have been created, but Claude session was not started."
  exit 0
fi

echo "Starting Claude session..."
echo ""

# Change to the worktree directory and start Claude
cd "$feature_path"

# Run Claude with the instructions
# Using all tools and reading from CLAUDE.md
if claude --help &> /dev/null; then
  # Try with standard flag
  claude "$(cat CLAUDE.md)"
else
  # Fallback if claude doesn't support standard invocation
  echo "Note: Running Claude with CLAUDE.md instructions"
  claude "$(cat CLAUDE.md)"
fi

echo ""
echo "Claude session completed."
echo "Worktree remains at: $feature_path"
