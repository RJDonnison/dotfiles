---
description: Acceptance-test a story's AC and NFRs against the deployed app via Playwright
agent: build
model: zai-coding-plan/glm-5.2
subtask: true
---

You are running acceptance testing for story $1 against the deployed test
environment at `https://csse-seng302-team100.canterbury.ac.nz/test/`

## 1. Gather requirements

Fetch the story, its acceptance criteria (AC), and its non-functional
requirements (NFR) for story ID `$1`.

#### ACs

Read:
stories/$1.json

If no file found run and read generated file:
scrumboard stories $1 -o stories/$1.json

#### NFRs

- NFR 1. There must be an appropriate amount of sensical data including user accounts
  to show all functionality works, i.e. if an AC requires 10 or more items for pagination,
  then there must be more than 10 items to show the pagination feature works.
- NFR 2. The product must maintain a consistent and accessible look and feel. Particularly,
  a. Colours and fonts must stay consistent across pages.
  b. The app must be responsive to different screen sizes – mobile to desktop.
  c. The app must offer a consistent user experience in terms of interactions with
  menus, buttons, links, or input fields, e.g., button placement and labelling are
  consistent across pages.
- NFR 3. The product must be both user friendly and fool-proof.
  a. users must be supported in their tasks by explicitly highlighting required fields
  and specifying the format if something specific is required (e.g., dates).
  b. All errors or fields that are invalid must be identifiable with a visual clue,
  helping users to correct these mistakes.
  c. All errors or fields that are invalid must be identified in one submission, i.e. if
  a form contains multiple errors, they are all displayed at once.
  d. Destructive actions must be confirmed explicitly, e.g., deletion.
  e. If there are input mistakes, entries/work-done must not be cleared (except for
  passwords).
- NFR 4. The product must accept all valid characters, included accentuated letters such
  as macrons (e.g., Māori, Müller, ...), and in some cases emojis (e.g., open text fields).
- NFR 5. When interacting with any highlightable element on the page (e.g., text fields, button),
  pressing tab must move the user to the next element in an ordered manner, so
  that screen reader can navigate your app. For example, pressing tab move down
  fields on a form, but does not move the cursor randomly between the different inputs.
- NFR 6. The system must show formatted data (e.g., date, time) in the users’ locale.

Parse the result into two lists:

- **Acceptance Criteria**: one item per AC, each testable via the UI.
- **NFRs**: one item per NFR. Note which ones are actually verifiable through
  browser interaction (e.g. response time on a page load, input validation,
  accessibility labels) versus ones that aren't (e.g. infra/deployment NFRs) —
  mark those "not verifiable via UI" rather than guessing a result.

If the fetch step returns nothing for `$1`, stop and report that the story
could not be found — do not invent AC or NFRs.

## 2. Set up the browser session

Using the Playwright MCP tools:

1. Navigate to `https://csse-seng302-team100.canterbury.ac.nz/test/login`.
2. Log in with:
   - Email: `john@example.com`
   - Password: `P4$$word`
3. Confirm login succeeded (check for a redirect away from the login page or
   a logged-in indicator) before proceeding. If login fails, stop and report
   this clearly — don't attempt the rest of the checklist against a logged-out
   session.

## 3. Test each Acceptance Criterion

For each AC in order:

- State which AC you're testing.
- Perform the minimum set of UI actions needed to exercise it (navigate,
  fill forms, click, etc.) using Playwright.
- Compare actual behaviour against the AC's expected outcome.
- Record: **Pass**, **Fail**, or **Blocked** (couldn't be tested, e.g. missing
  test data or unreachable page), with a one-line reason for Fail/Blocked.
- On a **Fail**, take a screenshot and note what the actual vs expected
  behaviour was.

## 4. Check each NFR

For NFRs marked verifiable via UI, do a lightweight check (e.g. timing a page
load, checking validation messages appear, checking basic accessibility
attributes). Record Pass/Fail/Blocked the same way. For NFRs marked "not
verifiable via UI" in step 1, just carry them into the report as such — don't
attempt to test them.

## 5. Report results

Produce **both**:

1. **Terminal summary** — a compact pass/fail/blocked count, followed by a
   one-line result per AC/NFR.
2. **Markdown report file** at `stories/reports/$1.md` containing:
   - Story ID, title, and date/time of the run
   - A table of AC results (AC text | result | notes)
   - A table of NFR results (NFR text | result | notes)
   - Any screenshots taken, referenced by file path
   - An overall verdict: story meets AC/NFRs as tested, or does not, with a
     short summary of what's outstanding

Create the `stories/reports/` directory if it doesn't exist. Don't
overwrite a previous report for the same story — if one exists, append a
timestamp to the new filename instead.
