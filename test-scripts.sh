#!/bin/bash

# Test script for cft and cftr

set -e

echo "Testing cft and cftr scripts..."
echo "================================"

# Test 1: Check if scripts exist and are executable
echo ""
echo "Test 1: Checking if scripts exist and are executable..."
if [ -x "./cft" ] && [ -x "./cftr" ]; then
  echo "✓ Both scripts exist and are executable"
else
  echo "✗ Scripts are missing or not executable"
  exit 1
fi

# Test 2: Check usage messages
echo ""
echo "Test 2: Checking usage messages..."
if ./cft 2>&1 | grep -q "Usage:"; then
  echo "✓ cft shows usage message when no arguments provided"
else
  echo "✗ cft doesn't show proper usage message"
  exit 1
fi

if ./cftr 2>&1 | grep -q "Usage:"; then
  echo "✓ cftr shows usage message when no arguments provided"
else
  echo "✗ cftr doesn't show proper usage message"
  exit 1
fi

# Test 3: Verify script syntax
echo ""
echo "Test 3: Verifying bash syntax..."
if bash -n ./cft && bash -n ./cftr; then
  echo "✓ Both scripts have valid bash syntax"
else
  echo "✗ Syntax errors found"
  exit 1
fi

# Test 4: Check for required commands in scripts
echo ""
echo "Test 4: Checking for essential git commands..."
if grep -q "git worktree add" ./cft && grep -q "git worktree remove" ./cftr; then
  echo "✓ Scripts contain git worktree commands"
else
  echo "✗ Missing git worktree commands"
  exit 1
fi

echo ""
echo "================================"
echo "All tests passed! ✓"
echo "================================"
echo ""
echo "Note: Full integration test requires running cft/cftr"
echo "which would need interactive editor input."
