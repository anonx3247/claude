# Usage Examples and Workflows

Real-world examples of using `cft` and `cftr` in various development scenarios.

## Table of Contents

1. [Basic Feature Development](#basic-feature-development)
2. [Bug Fixes](#bug-fixes)
3. [Test Automation](#test-automation)
4. [Documentation](#documentation)
5. [Refactoring](#refactoring)
6. [Parallel Development](#parallel-development)
7. [Emergency Hotfixes](#emergency-hotfixes)
8. [Code Review Automation](#code-review-automation)

---

## Basic Feature Development

### Scenario: Add user authentication

```bash
# Start Claude on authentication feature
cft add-user-authentication
```

**In the editor, write:**
```
Add JWT-based user authentication to the API:
- POST /api/auth/login endpoint
- POST /api/auth/register endpoint  
- JWT token generation and validation
- Password hashing with bcrypt
- Authentication middleware
- Comprehensive tests (unit + integration)
- Update API documentation
```

**What Claude does:**
1. Explores existing codebase structure
2. Creates auth routes and controllers
3. Implements JWT token logic
4. Adds password hashing
5. Creates middleware
6. Writes comprehensive tests
7. Updates documentation
8. Creates pull request

**Clean up when done:**
```bash
cftr add-user-authentication
```

---

## Bug Fixes

### Scenario: Memory leak in React component

```bash
cft fix-gallery-memory-leak
```

**In the editor:**
```
Fix memory leak in Gallery component:
- Event listeners on window not being removed
- useEffect missing cleanup function
- Images not being released from memory
Add tests to prevent regression
```

**Claude will:**
1. Locate the Gallery component
2. Identify missing cleanup in useEffect
3. Add proper cleanup functions
4. Add memory leak tests
5. Create PR with fix

---

## Test Automation

### Scenario: Add tests to existing code

```bash
cft add-payment-tests
```

**In the editor:**
```
Add comprehensive test coverage for payment processing:
- Unit tests for payment service
- Integration tests for payment endpoints
- Mock Stripe API
- Test edge cases (failed payments, refunds, etc.)
- Achieve 90%+ coverage
```

**Alternatively, let Claude infer:**
```bash
cft test-user-authentication
# Leave editor empty - Claude will infer: "Add tests for user authentication"
```

---

## Documentation

### Scenario: Generate API documentation

```bash
cft document-api-endpoints
```

**In the editor:**
```
Create comprehensive API documentation:
- OpenAPI/Swagger spec for all endpoints
- README with usage examples
- Authentication flow diagram
- Error code reference
- Rate limiting documentation
```

**Or just:**
```bash
cft add-readme
# Claude will create a comprehensive README based on codebase analysis
```

---

## Refactoring

### Scenario: Modernize legacy code

```bash
cft refactor-user-service
```

**In the editor:**
```
Refactor user service to modern standards:
- Convert callbacks to async/await
- Extract business logic from routes
- Add proper error handling
- Improve type safety
- Keep all existing functionality
- Ensure 100% test coverage
```

---

## Parallel Development

### Scenario: Work on feature while Claude handles another

```bash
# You work on main feature manually
ft implement-shopping-cart
cd ../myproject-implement-shopping-cart
# ... you code the shopping cart ...

# Meanwhile, have Claude work on related feature
cft add-payment-integration
# Claude implements payment integration in parallel

# Both worktrees exist side by side:
# ../myproject-implement-shopping-cart (you)
# ../myproject-add-payment-integration (Claude)

# When done, review both:
# 1. Review your shopping cart code
# 2. Review Claude's payment integration PR
# 3. Merge both if satisfied

# Clean up
ftr implement-shopping-cart
cftr add-payment-integration
```

---

## Emergency Hotfixes

### Scenario: Critical production bug

```bash
# Quick hotfix with Claude
cft hotfix-xss-vulnerability
```

**In the editor:**
```
URGENT: Fix XSS vulnerability in comment rendering
- Sanitize user input before display
- Add input validation
- Test with XSS payloads
- Create security test suite
Target: Complete in 15 minutes
```

**Claude prioritizes:**
1. Quick fix first
2. Validation and sanitization
3. Security tests
4. Fast PR for immediate deployment

---

## Code Review Automation

### Scenario: Claude reviews your code

```bash
# After you finish your feature manually
ft my-new-feature
# ... you write code ...
git commit -am "Add new feature"
git push

# Have Claude review it
cft review-my-new-feature
```

**In the editor:**
```
Review the code in branch 'my-new-feature':
- Check for security issues
- Verify error handling
- Suggest performance improvements
- Check test coverage
- Verify code style compliance
Create detailed review comments as PR review
```

---

## Real-World Workflow Examples

### Example 1: Full-Stack Feature

```bash
# 1. Create backend API
cft api-user-profiles
# Instructions: "Create REST API for user profiles with CRUD operations"

# 2. Wait for PR, review and merge

# 3. Create frontend
cft ui-user-profiles  
# Instructions: "Create React components for user profile management, 
#                consuming the user profiles API"

# 4. Add integration tests
cft test-user-profile-integration
# Instructions: "Add E2E tests for user profile feature"

# 5. Clean up all
cftr api-user-profiles
cftr ui-user-profiles
cftr test-user-profile-integration
```

### Example 2: Incremental Improvement

```bash
# Sprint 1: MVP
cft mvp-analytics-dashboard
# Instructions: "Create basic analytics dashboard with key metrics"

# Sprint 2: Add features
cft analytics-add-charts
# Instructions: "Add interactive charts to analytics dashboard"

# Sprint 3: Optimization
cft analytics-performance-optimization
# Instructions: "Optimize analytics queries and add caching"

# Sprint 4: Polish
cft analytics-ui-polish
# Instructions: "Improve dashboard UI/UX based on feedback"
```

### Example 3: Migration Project

```bash
# Phase 1: Prepare
cft migrate-prep-database
# Instructions: "Create migration scripts for database schema v2"

# Phase 2: Migrate code
cft migrate-update-models
# Instructions: "Update all data models for new schema"

# Phase 3: Tests
cft migrate-add-tests
# Instructions: "Add migration tests and rollback procedures"

# Phase 4: Documentation
cft migrate-document-process
# Instructions: "Document migration process and rollback steps"
```

---

## Tips for Best Results

### Write Clear Instructions

**Good:**
```
Add user registration with email verification:
- Email validation
- Send verification email with token
- Verify endpoint
- Expire tokens after 24 hours
- Tests for all flows
```

**Less Good:**
```
do user stuff
```

### Let Claude Infer When Appropriate

For self-explanatory branch names:
```bash
cft fix-typo-in-readme        # No instructions needed
cft update-dependencies       # No instructions needed
cft add-missing-tests         # Claude will analyze coverage
```

### Combine with Manual Work

```bash
# You design, Claude implements
# 1. Create design doc manually
# 2. Have Claude implement it
cft implement-design-from-doc
# Instructions: "Implement the design in DESIGN.md"
```

### Use for Learning

```bash
# Learn new technologies
cft learn-websockets-example
# Instructions: "Create a simple chat application using WebSockets
#                with detailed comments explaining each part"
```

---

## Common Patterns

### Pattern 1: Feature + Tests

```bash
cft add-feature-x          # Claude implements feature
cftr add-feature-x         # Review and merge
cft test-feature-x         # Claude adds comprehensive tests
cftr test-feature-x        # Review and merge
```

### Pattern 2: Implement + Document

```bash
cft implement-api-v2       # Claude implements
cft document-api-v2        # Claude documents
# Review both PRs
cftr implement-api-v2
cftr document-api-v2
```

### Pattern 3: Fix + Prevent

```bash
cft fix-security-issue     # Claude fixes the issue
cft add-security-tests     # Claude adds tests to prevent recurrence
```

---

## Troubleshooting Scenarios

### Claude didn't create PR

```bash
# Check the worktree
cd ../myproject-my-feature

# Review what Claude did
git status
git log

# Manually create PR if needed
git push
# Create PR via GitHub UI

# Or let Claude try again
cft my-feature-retry
# Instructions: "Create PR for the my-feature branch"
```

### Need to modify Claude's work

```bash
# Don't clean up yet - modify in worktree
cd ../myproject-my-feature

# Make your changes
vim some-file.js
git commit -am "Improve Claude's implementation"
git push

# Update PR, then clean up
cftr my-feature
```

### Want different approach

```bash
# Keep first attempt
# Try alternative approach
cft my-feature-alt
# Instructions: "Alternative approach: [describe]"

# Compare both PRs
# Choose best one
# Clean up both
cftr my-feature
cftr my-feature-alt
```

---

## Integration with CI/CD

After Claude creates PR:

```yaml
# .github/workflows/claude-pr.yml
name: Validate Claude PR

on:
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: npm test
      - name: Lint
        run: npm run lint
      - name: Type check
        run: npm run typecheck
```

Claude's PRs go through same CI/CD as manual PRs!

---

## Summary

The `cft` and `cftr` scripts enable:
- **Autonomous feature development** by Claude
- **Parallel work streams** (you + Claude)
- **Rapid prototyping** and experimentation
- **Automated testing** and documentation
- **Code review** assistance
- **Learning** and exploration

Experiment with different workflows to find what works best for your team!

---

**Pro Tip:** Start with small, well-defined tasks to learn how Claude works, then gradually increase complexity.
