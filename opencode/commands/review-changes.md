---
description: Review uncommitted changes and suggest improvements
---

1. Run `git status` to identify modified, staged, and untracked files
2. Run `git diff` for unstaged changes
3. Run `git diff --cached` for staged changes
4. For untracked files, read their contents directly

For each changed or new file, analyze:

- Correctness — does the logic do what it intends?
- Completeness — are there missing cases, TODOs, or half-finished changes?
- Bugs — off-by-one errors, null/undefined handling, type mismatches
- Security — injection risks, exposed secrets, unsafe input handling
- Error handling — are errors caught, logged, and handled appropriately?
- Conventions — check existing files and CONTRIBUTING.md for style patterns

## Output Format

For each file:
**filename** — ✓ looks good / ⚠ minor concerns / ✗ needs work

- Specific finding with line reference if relevant

**Recommended action:** one of:

- Ready to commit
- Fix X before committing
- Needs tests before committing
