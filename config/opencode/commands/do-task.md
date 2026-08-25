---
description: Complete one or more tasks from scrumboard
model: zai-coding-plan/glm-5.2
---

You are executing Scrum tasks autonomously. Task IDs: $ARGUMENTS (one or more,
space-separated).

Split $ARGUMENTS into a list of task IDs. Process the list sequentially, one
task at a time, fully completing each task (steps 1-16 below) before starting
the next. Do NOT hand back to the user mid-task. Do NOT include comments,
except for xml comments and whole function comments.

For each task ID (call it $TASK_ID) in order:

Read:

- tasks/$TASK_ID.json
- DESIGN.md only if style decisions are required
- Relevant files only

Steps:

1. Verify current git branch contains the task id $TASK_ID, stop if it doesn't.
2. Run:
   scrumboard task $TASK_ID --include-acs -o tasks/$TASK_ID.json
3. Read all generated files in tasks/.
4. Send the task to @plan agent.
5. Send the resulting plan to @staff-reviewer.
6. Allow a maximum of 3 review cycles.
7. Present the approved plan to the user.
8. Wait for explicit user approval.
9. After approval:
   - Implement the plan.
   - Create missing tests.
   - Run `dotnet test`.
   - Automatically fix failures.
10. Run @code-simplifier
11. Run @task-reviewer.
12. If review fails:
    - Fix issues.
    - Re-review.
    - Maximum 3 cycles.
13. Run `dotnet test` again.
14. Confirm:
    - Task requirements met
    - Acceptance criteria met
    - Definition of done met
    - All tests pass
15. Delete task file(s) from `tasks/`.
16. Produce a summary for $TASK_ID.
17. Do NOT commit.

After all task IDs have been processed, produce one combined summary covering
every task completed in this run.
