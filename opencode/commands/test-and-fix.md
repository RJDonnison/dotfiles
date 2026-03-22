---
description: Run tests and fix any failures
---

1. Discover the test command — check `package.json` scripts, `Makefile`, `pytest.ini`, or `README`
2. Check for missing dependencies (`node_modules`, virtualenv, etc.) and missing `.env` files before running
3. Run the full test suite
4. If all tests pass, report success and stop

If tests fail:

- Distinguish environment failures (missing deps, bad config) from actual test failures — fix environment issues first
- For each failing test, identify root cause: is the implementation wrong, or is the test itself outdated/incorrect?
- Only modify a test if it is clearly testing the wrong thing — never change a test just to make it pass
- Fix one failure at a time, then re-run only that test file to verify before moving on
- After all individual fixes, run the full suite once more to catch regressions

**Bail-out rule:** If a single test is still failing after 3 fix attempts, stop, report what was tried, and ask for guidance. Do not loop indefinitely.

Report at the end:

- Tests fixed (what was wrong, what was changed)
- Any tests skipped or bailed out on (and why)
- Any environmental issues found
