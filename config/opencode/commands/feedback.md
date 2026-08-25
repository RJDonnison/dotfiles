---
description: >-
  Generate week (self) or sprint (teammate) reflection feedback for a given
  team usercode, using data from `scrumboard export`, your own reflections,
  and the humanizer agent for a final polish pass.
agent: build
---

Treat $1 as `USERCODE`. If
no argument was given, ask which usercode to run this for and stop until you
get an answer — don't guess.

## 1. Resolve who this is about and which mode applies

Team roster (usercode → name):

| usercode | name       |
| -------- | ---------- |
| rdo80    | me (self)  |
| ige22    | Ilan       |
| smv39    | Sumi       |
| amb352   | Anna-Marie |
| asi182   | Archie     |
| gga54    | George     |

- If `USERCODE` is `rdo80` → **week mode**, subject is the user themself.
- If `USERCODE` matches another row → **sprint mode**, subject is that
  person's name.
- If `USERCODE` doesn't match any row, stop and ask the user to confirm the
  code or add it to the mapping — don't guess a name.

Every answer you produce is written from **my (rdo80's) point of view** —
even in week mode, where "my" reflections are about myself. **Never print
the raw usercode anywhere in the final output** — use the resolved name (or
"I"/"me" for rdo80) instead.

## 2. Get the scrumboard data

`scrumboard export -o <path>` produces a full export of the **current
sprint** for the whole team (not filterable by user at export time), so:

1. Look for an export already on disk first. Glob for recent export files
   (e.g. `exports/*.json`, `*export*.json`, `scrumboard*.json` — check
   common locations like the repo root and an `exports/` folder). If one
   exists and looks like it's from today or this session, read it and skip
   step 2.
2. Otherwise, run:

   ```
   scrumboard export -o exports/export-$(date +%Y-%m-%d).json
   ```

   creating the `exports/` directory first if needed, then read the
   resulting file.

Once loaded, filter/extract everything in the export relevant to
`USERCODE`: tasks assigned to them, their status changes, comments, hours
logged, blockers, dates — whatever the export contains. This is your only
source of factual, data-backed claims. Do not invent tasks, dates, hours, or
outcomes that aren't in the export or in what the user tells you directly in
step 3.

If the export contains no data at all for `USERCODE`, say so plainly rather
than padding the summary — an honest "no recorded activity this sprint" beats
a fabricated one.

## 3. Ask the reflection questions

Ask these conversationally, in your own message (not as multiple-choice
buttons — they're open reflection questions). Ask all three together, wait
for the user's real answer before drafting anything.

**If week mode (USERCODE = rdo80):**

> **What are you proud of this week?**
> Reflect on your contributions and learning moments this week across all
> areas, including project work, team collaboration, and personal
> development. Remember to refer to your personal goals from last week. What
> achievements are you proud of? How did you go with your prior goals?
> Highlight specific interactions or tasks where you excelled and reflect on
> what made them successful, including any skills or knowledge that
> contributed to their success.
>
> **What could you have done better?**
> Think about areas for improvement, e.g., in your feature development work,
> in your interactions with your team, in your processes. Feel free to
> analyse any challenges you faced. Where did you fall short of your own
> expectations? Reflect on any missed opportunities for leadership,
> collaboration, or learning, and consider what you can take from the
> experience.
>
> **What are your goals for next week?**
> Based on this week's reflections, identify concrete actions you can take
> to improve your skills. What changes or new strategies would you like to
> try going forward? Think about adjustments to your current approach or new
> processes you want to build. Set clear, actionable goals to turn your
> reflections into meaningful progress.

**If sprint mode (USERCODE = a teammate):** ask the same three questions,
but reframed as _my_ observations of _them_ this sprint — you (the user) are
answering, I am drafting on your behalf afterward:

> What did your partner do well?
>
> Give justifications and concrete examples to support the above scores. Avoid generic statements like 'They had good communication'.
> What did your partner do not so well? Make sure to link this to impact on the team or product.
>
> What could they improve on? Avoid generic statements like ' They had bad communication' but give examples of what they did, and how they could improve (think SMART). Make sure to link this to impact on the team or product. Include at least one SMART goal related to the improvements.

## 4. Draft the answers

Combine the user's real answers from step 3 with the concrete facts pulled
from the export in step 2 into a full written answer for each of the three
questions. Rules:

- The export supplies facts (what happened); the user's answer supplies the
  actual judgment, feelings, and priorities. Don't let one silently override
  the other — if the user's stated view conflicts with what the export
  shows, keep the user's view but you may note the discrepancy.
- Reference specific tasks/events from the export where they support a
  point ("shipped the auth refactor," "three days blocked on the CI
  pipeline") rather than staying generic.
- Sprint mode answers are written in first person about the teammate ("I
  thought Ilan handled the API migration well because...") — never as if
  Ilan wrote it themselves, and never including their usercode.
- Don't invent goals, achievements, or blockers that weren't in the export
  or the user's own answer.
- Keep the three-question structure with clear headers matching the
  question mode used (week or sprint wording).
- All goals created should be SMART goals (Specific, Measurable, Achievable, Relevant, Time-bound)

## 5. Humanize the draft

Pass the full drafted answer (all three Q&A sections) to the @humanizer
subagent to strip AI-writing tells and make it read naturally, before
showing it to the user. Preserve every fact and the first-person point of
view — humanizer should only change the prose, not the content or the
Q&A structure.

## 6. Deliver

Present the final humanized week/sprint reflection in chat, structured as
the three questions (in the mode-appropriate wording) each followed by its
answer. Don't save a file unless the user asks for one.
