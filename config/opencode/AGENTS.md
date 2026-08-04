# Agent instructions

## Search

Always use the `searxng` MCP tool for web searches. Do not use any other
search tool or method unless `searxng` is unavailable.

## Diagrams

Use the `mermaid` MCP tool to generate diagrams (flowcharts, sequence
diagrams, architecture diagrams, etc.) rather than describing them in text
or drawing ASCII art.

## Browser automation / Playwright

When using the `playwright` MCP tool, note that Chromium may be installed
at a non-default system path. If browser launch fails with an
"Executable doesn't exist" error, check for a `PLAYWRIGHT_CHROMIUM_PATH`
env var before assuming Playwright's browsers aren't installed.

## Tool-using tasks

Tool calls (browser automation, MCP search, file edits, running commands)
require Build mode - Plan mode has restricted tool access and analysis
only. If a task needs tools and the current agent is Plan, say so rather
than silently failing or attempting a workaround.

## Formatting

- C# files: formatted with `dotnet format`. Don't
  hand-format C# - let the formatter run on save/commit.
- JS/TS: Prettier.
- Rust: rustfmt.

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

For small/obvious changes (typos, config tweaks, single-line fixes): skip steps 1, and 3.

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

<!-- context7 -->

Use Context7 MCP to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service — even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer — your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

## Steps

1. Always start with `resolve-library-id` using the library name and what to look up in the library's documentation, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question). Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and what to look up in the library's documentation (not single words), scoped to a single concept. If the question spans multiple distinct concepts (e.g. routing and auth and caching), make a separate `query-docs` call per concept with the same library ID, unless the question is about how the concepts interact — combined queries dilute ranking and return shallow results for each topic
4. Answer using the fetched docs
<!-- context7 -->
