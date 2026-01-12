#!/bin/bash

# cft - Claude Feature Task
# Creates a git worktree and starts a Claude session to work on a feature branch
# Based on the ft (feature task) function pattern

set -e

if [ -z "$1" ]; then
  echo "Usage: cft <branch-name>"
  echo ""
  echo "Creates a git worktree for the branch and starts a Claude AI session."
  echo "Claude will work on the feature autonomously and create a PR."
  exit 1
fi

feature_name=$1

# Validate we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: Not in a git repository"
  exit 1
fi

# Check if branch exists, create only if it doesn't
if ! git show-ref --verify --quiet refs/heads/"$feature_name"; then
  echo "Creating branch: $feature_name"
  git branch "$feature_name"
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
  echo "Worktree already exists at: $feature_path"
fi

# Determine editor to use
editor=${EDITOR:-hx}

# Create temporary file for prompt
prompt_file=$(mktemp /tmp/claude-prompt.XXXXXX)

# Create prompt template
cat > "$prompt_file" << 'TEMPLATE_EOF'
# Claude Task Instructions
# 
# Branch: BRANCH_NAME_PLACEHOLDER
#
# Instructions:
# Write your specific task description below. Be as detailed as needed.
# If you leave this empty (delete these comment lines), Claude will
# infer the task from the branch name.
#
# Example instructions:
# - "Add user authentication with JWT tokens"
# - "Fix the memory leak in the Gallery component"
# - "Refactor the user service to use async/await"
#

TEMPLATE_EOF

# Replace placeholder with actual branch name
sed -i "s/BRANCH_NAME_PLACEHOLDER/$feature_name/" "$prompt_file"

# Open editor for user input
echo ""
echo "Opening $editor to write task instructions..."
echo "Save and close when done."
echo ""

if ! $editor "$prompt_file" 2>/dev/null; then
  echo "Warning: Editor exited with non-zero status"
fi

# Read and clean the prompt
prompt=$(grep -v '^#' "$prompt_file" | grep -v '^\s*$' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

# Clean up temp file
rm -f "$prompt_file"

# Determine the task description
if [ -z "$prompt" ]; then
  echo "No specific instructions provided."
  echo "Claude will infer the task from branch name: $feature_name"
  task_description="Based on the branch name '$feature_name', determine what needs to be done and implement it."
else
  echo "Task instructions captured."
  task_description="$prompt"
fi

# Copy the comprehensive CLAUDE.md template to worktree if it exists
if [ -f "$project_dir/CLAUDE.md" ]; then
  cp "$project_dir/CLAUDE.md" "$feature_path/CLAUDE.md"
  echo "Copied CLAUDE.md template to worktree"
fi

# Create or append the PROJECT_TASK.md with specific instructions
cat > "$feature_path/PROJECT_TASK.md" << TASK_EOF
# Project Task

## Branch
\`$feature_name\`

## Objective
Create a pull request for this feature/fix after exploring, planning, implementing, and testing.

## Task Description

$task_description

## Workflow

1. **Explore** - Read and understand the existing codebase structure
2. **Plan** - Create a clear implementation plan
3. **Implement** - Write the code following best practices from CLAUDE.md
4. **Test** - Ensure comprehensive test coverage (80%+)
5. **Validate** - Run linters, type checkers, and all tests
6. **Document** - Add necessary documentation
7. **Commit & Push** - Commit changes with clear messages
8. **Create PR** - Create a detailed pull request

## Tools Available

You have full access to:
- File operations (read, write, edit files)
- Shell commands (run tests, lint, build, etc.)
- Git operations (commit, push, create branches)
- All development tools in the environment

## Success Criteria

- [ ] All tests pass
- [ ] No linting errors
- [ ] No type errors (if applicable)
- [ ] Code coverage >= 80% (if applicable)
- [ ] Clear commit messages
- [ ] Detailed PR description
- [ ] Code follows patterns in CLAUDE.md

TASK_EOF

echo "Created PROJECT_TASK.md with task details"
echo ""
echo "=========================================="
echo "Worktree ready at: $feature_path"
echo "=========================================="
echo ""

# Check if claude command exists
if ! command -v claude &> /dev/null; then
  echo "Warning: 'claude' command not found in PATH"
  echo ""
  echo "Worktree has been set up with:"
  echo "  - CLAUDE.md (comprehensive guidelines)"
  echo "  - PROJECT_TASK.md (specific task instructions)"
  echo ""
  echo "To start Claude manually:"
  echo "  cd $feature_path"
  echo "  claude -allow all"
  exit 0
fi

echo "Starting Claude session with all tools enabled..."
echo ""

# Change to worktree directory
cd "$feature_path"

# Construct the initial prompt for Claude
initial_prompt="You are working in a git worktree for branch '$feature_name'.

Read the following files to understand your task and guidelines:
1. PROJECT_TASK.md - Your specific task and objectives
2. CLAUDE.md - Development guidelines and best practices for this project

After reading these files, execute the workflow described in PROJECT_TASK.md to complete the task and create a pull request.

Start by reading both files to understand what needs to be done."

# Start Claude with all tools enabled
echo "$initial_prompt" | claude -allow all

echo ""
echo "=========================================="
echo "Claude session completed"
echo "=========================================="
echo ""
echo "Worktree remains at: $feature_path"
echo "Branch: $feature_name"
echo ""
echo "Next steps:"
echo "  - Review the changes in the worktree"
echo "  - Check if Claude created a PR"
echo "  - Clean up when done: cftr $feature_name"
