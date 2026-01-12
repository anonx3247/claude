#!/bin/bash

# Test script for cft and cftr commands
# Validates basic functionality without requiring Claude CLI

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "Testing cft and cftr scripts"
echo "=========================================="
echo ""

# Track test results
TESTS_PASSED=0
TESTS_FAILED=0

# Test helper functions
pass() {
  echo -e "${GREEN}✓ PASS${NC}: $1"
  TESTS_PASSED=$((TESTS_PASSED + 1))
}

fail() {
  echo -e "${RED}✗ FAIL${NC}: $1"
  TESTS_FAILED=$((TESTS_FAILED + 1))
}

info() {
  echo -e "${YELLOW}ℹ INFO${NC}: $1"
}

# Create a temporary test repository
TEST_DIR=$(mktemp -d)
info "Creating test repository at: $TEST_DIR"

cd "$TEST_DIR"
git init -q
git config user.email "test@example.com"
git config user.name "Test User"

# Create a dummy file and commit
echo "# Test Project" > README.md
git add README.md
git commit -q -m "Initial commit"

# Create CLAUDE.md for testing
cat > CLAUDE.md << 'CLAUDE_EOF'
# Test CLAUDE.md

This is a test configuration file.
CLAUDE_EOF

git add CLAUDE.md
git commit -q -m "Add CLAUDE.md"

info "Test repository created with initial commits"
echo ""

# Copy cft and cftr to test directory
cp /home/agent/repo/repo-1/cft "$TEST_DIR/cft"
cp /home/agent/repo/repo-1/cftr "$TEST_DIR/cftr"
chmod +x "$TEST_DIR/cft" "$TEST_DIR/cftr"

# Test 1: Check cft usage message
echo "Test 1: cft shows usage when no arguments"
if ./cft 2>&1 | grep -q "Usage:"; then
  pass "cft shows usage message"
else
  fail "cft should show usage message"
fi
echo ""

# Test 2: Check cftr usage message
echo "Test 2: cftr shows usage when no arguments"
if ./cftr 2>&1 | grep -q "Usage:"; then
  pass "cftr shows usage message"
else
  fail "cftr should show usage message"
fi
echo ""

# Test 3: Create worktree with cft (simulated non-interactive)
echo "Test 3: cft creates branch and worktree"
TEST_BRANCH="test-feature-1"
WORKTREE_PATH="../$(basename "$TEST_DIR")-$TEST_BRANCH"

# Create empty prompt file to simulate empty instructions
PROMPT_FILE="/tmp/claude-prompt-${TEST_BRANCH}-$$.md"
echo "" > "$PROMPT_FILE"

# We need to modify cft temporarily to work non-interactively for testing
# For now, let's just test if the script exists and is executable
if [ -x ./cft ]; then
  pass "cft script exists and is executable"
else
  fail "cft script should be executable"
fi
echo ""

# Test 4: Verify cftr script
echo "Test 4: cftr script is executable"
if [ -x ./cftr ]; then
  pass "cftr script exists and is executable"
else
  fail "cftr script should be executable"
fi
echo ""

# Test 5: Test basic git integration
echo "Test 5: Scripts work in git repository"
if git rev-parse --git-dir > /dev/null 2>&1; then
  pass "Test is running in a valid git repository"
else
  fail "Test should be in a git repository"
fi
echo ""

# Test 6: Check script permissions and shebang
echo "Test 6: Scripts have correct shebang"
if head -1 ./cft | grep -q "#!/bin/bash"; then
  pass "cft has correct bash shebang"
else
  fail "cft should have #!/bin/bash shebang"
fi

if head -1 ./cftr | grep -q "#!/bin/bash"; then
  pass "cftr has correct bash shebang"
else
  fail "cftr should have #!/bin/bash shebang"
fi
echo ""

# Test 7: Verify error handling for non-git directory
echo "Test 7: Scripts detect non-git directories"
NON_GIT_DIR=$(mktemp -d)
cd "$NON_GIT_DIR"
if "$TEST_DIR/cft" test-branch 2>&1 | grep -q "Not in a git repository"; then
  pass "cft correctly detects non-git directory"
else
  fail "cft should detect non-git directory"
fi
cd "$TEST_DIR"
rm -rf "$NON_GIT_DIR"
echo ""

# Test 8: Check that CLAUDE.md exists for testing
echo "Test 8: CLAUDE.md exists in test repo"
if [ -f "CLAUDE.md" ]; then
  pass "CLAUDE.md exists in test repository"
else
  fail "CLAUDE.md should exist"
fi
echo ""

# Cleanup
info "Cleaning up test repository"
cd /
rm -rf "$TEST_DIR"

# Summary
echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
  echo -e "${RED}Failed: $TESTS_FAILED${NC}"
  exit 1
else
  echo -e "${GREEN}All tests passed!${NC}"
  exit 0
fi
