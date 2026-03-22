# Agent Orchestration Rules

## Agent Selection

- Use **staff-reviewer** before implementation begins — it critiques plans, not code
- Use **code-architect** when structural or design changes are being planned
- Use **code-simplifier** after implementation, before committing
- Never invoke staff-reviewer and code-architect on the same task — pick one
- If staff-reviewer returns NEEDS RETHINK, stop and surface the concern to the user before proceeding

## Standard Workflow

For any non-trivial change:

1. staff-reviewer (validate the plan)
2. Implement
3. code-simplifier (clean up)
4. test-and-fix command (verify nothing broke)
5. docs-writer (create docs)
6. review-changes command (final check before commit)

For small/obvious changes (typos, config tweaks, single-line fixes): skip to step 4.

## Parallel Work

- Only one agent should edit a given file at a time
- Prefer sequential agents over parallel when quota is a concern

## Cost & Quota

- Do not invoke multiple heavy agents in parallel
- If quota errors occur, stop and report rather than retrying automatically

## Universal Rules (apply to all agents and commands)

- Never assume `npm` — discover the test command from package.json, Makefile, or README
- Never run the full test suite repeatedly when only one test is failing — isolate first
- Never modify a test just to make it pass
- Bail out after 3 failed fix attempts on the same problem and ask for guidance
- Do not make breaking API changes without surfacing them to the user first
