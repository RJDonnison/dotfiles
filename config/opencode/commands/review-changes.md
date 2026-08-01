---
description: Review changes in branch and suggest improvements
---

1. Run `git status` to identify modified, staged, and untracked files
2. Run `git diff dev` for changes in branch
3. For untracked files, read their contents directly

For each changed or new file, analyze:

- Correctness — does the logic do what it intends?
- Completeness — are there missing cases, TODOs, or half-finished changes?
- Bugs — off-by-one errors, null/undefined handling, type mismatches
- Security — injection risks, exposed secrets, unsafe input handling
- Error handling — are errors caught, logged, and handled appropriately?
- Conventions — check existing files and CONTRIBUTING.md for style patterns
- Tests — check that tests have been written or updated for changes

## Output Format

For each file:
**filename** — ✓ looks good / ⚠ minor concerns / ✗ needs work

- Specific finding with line reference if relevant

**Recommended action:** one of:

- Ready to merge
- Fix X before merging
- Needs tests before merging
