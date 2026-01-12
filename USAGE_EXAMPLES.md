# Usage Examples

## Example 1: Simple Feature Development

```bash
# Start Claude on a new feature
./cft.sh add-dark-mode

# Editor opens with template:
# Claude Task Instructions
# 
# Branch: add-dark-mode
#
# Write your instructions below...

# You type:
"Add dark mode support to the application. Include a toggle button in the header 
and persist the user's preference in localStorage."

# Claude then:
# 1. Explores the codebase
# 2. Finds relevant components
# 3. Implements dark mode CSS/logic
# 4. Adds toggle button
# 5. Implements localStorage persistence
# 6. Tests the implementation
# 7. Creates a PR with description

# Later, clean up:
./cftr.sh add-dark-mode
```

## Example 2: Bug Fix

```bash
# Start Claude on a bug fix
./cft.sh fix-memory-leak

# In editor, describe the bug:
"Users report memory leaks when navigating between pages. 
Event listeners are not being cleaned up properly in the Gallery component.
Fix the memory leak and add proper cleanup."

# Claude will:
# 1. Analyze the Gallery component
# 2. Identify the event listener issue
# 3. Add proper cleanup in useEffect/componentWillUnmount
# 4. Test for memory leaks
# 5. Create PR with fix

./cftr.sh fix-memory-leak
```

## Example 3: Let Claude Decide (Empty Prompt)

```bash
# Start Claude with just a descriptive branch name
./cft.sh refactor-user-service

# In editor, you just save without adding anything (or delete all comments)
# Claude sees the branch name and decides:
"The branch name suggests refactoring the user service. 
Let me explore the codebase to understand what needs to be refactored..."

# Claude autonomously:
# 1. Finds user service code
# 2. Identifies improvement opportunities
# 3. Plans refactoring strategy
# 4. Implements improvements
# 5. Ensures tests pass
# 6. Creates PR

./cftr.sh refactor-user-service
```

## Example 4: Test Addition

```bash
./cft.sh add-tests-auth-module

# Instructions:
"Add comprehensive unit tests for the authentication module.
Cover all edge cases including invalid tokens, expired sessions, and concurrent logins."

# Claude adds tests with high coverage

./cftr.sh add-tests-auth-module
```

## Example 5: Documentation

```bash
./cft.sh update-api-docs

# Instructions:
"Update API documentation to reflect recent changes to the REST endpoints.
Include examples and response formats."

# Claude updates docs

./cftr.sh update-api-docs
```

## Example 6: Integration with Existing Workflow

You can mix manual worktrees with Claude worktrees:

```bash
# You work on the main feature manually
ft implement-payment-system
# ... you code in ../myproject-implement-payment-system

# Ask Claude to add tests in parallel
cft add-payment-tests
# Instructions: "Add unit and integration tests for the payment system in branch implement-payment-system"
# Claude creates tests

# Ask Claude to add documentation
cft document-payment-api
# Claude adds documentation

# You review Claude's PRs, merge them, clean up
cftr add-payment-tests
cftr document-payment-api

# You continue your main work
ftr implement-payment-system
```

## Tips

### Descriptive Branch Names
Claude works best with descriptive branch names:
- ✅ Good: `fix-login-validation-error`
- ✅ Good: `add-user-profile-page`
- ❌ Bad: `stuff`
- ❌ Bad: `test123`

### Clear Instructions
Be specific in your instructions:
- ✅ "Add email validation to the signup form using regex pattern for RFC 5322 compliance"
- ❌ "Fix email thing"

### Incremental Tasks
Break large tasks into smaller ones:
```bash
cft add-user-auth-backend
cft add-user-auth-frontend  
cft add-user-auth-tests
```

Better than:
```bash
cft implement-entire-user-system  # Too broad
```

## Integration with Your Aliases

These work alongside your existing git aliases:

```bash
# Your workflow
ggm                    # git checkout main
gb feature-x           # Create branch manually
ft feature-x           # Create worktree manually
# ... you code ...
ga -u                  # Stage files
gc "Add feature X"     # Commit
gp                     # Push
ftr feature-x          # Clean up

# Claude workflow
ggm                    # git checkout main
cft feature-y          # Claude creates worktree and works
# ... Claude codes and creates PR ...
# ... you review and merge ...
cftr feature-y         # Clean up
```
