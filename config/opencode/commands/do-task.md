---
description: Complete a task from scrumboard
model: opencode-go/qwen3.7-max
---

You are executing a Scrum task autonomously. You will follow the steps below to complete the task, ensuring that all requirements and acceptance criteria are met. DO NOT hand back to the user until the task is fully completed and all tests pass. Do NOT include comments, except for xml comments and whole function comments.

Task ID: $1

Read:

- tasks/$1.json
- DESIGN.md only if style decisions are required
- Relevant files only

Steps:

1. Verify current git branch contains the task id $1, stop if it doesn't.
2. Run:

   scrumboard task $1 --include-acs -o tasks/

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

16. Produce a summary.

17. Do NOT commit.
