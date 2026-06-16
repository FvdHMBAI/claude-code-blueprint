---
name: example-skill
description: Template skill demonstrating the Learnings Loop pattern
---

# Example Skill with Learnings Loop

This skill demonstrates how to integrate self-improvement into any workflow.

## Before Execution

1. Read `learnings.md` in this directory (if it exists)
2. Apply any relevant learnings to the current task
3. Note which learnings you applied (for Runs tracking)

## Skill Logic

<!-- Replace this section with your actual skill workflow -->

1. Analyze the current situation
2. Perform the required action
3. Verify the result

## After Execution

1. **Increment Runs:** For each learning you applied during this session, increment its `Runs` counter by 1
2. **New Learning:** If something unexpected happened that could help in future sessions, add a new entry to `learnings.md` (check for duplicates first)
3. **Crystallization Check:** If any learning has `Score >= 4` AND `Runs >= 3`, crystallize it:
   - Extract the learning as a permanent rule
   - Add it to this `SKILL.md` file
   - Mark it as `**Status: CRYSTALLIZED**` in `learnings.md`

## Crystallized Rules

<!-- Rules that proved themselves 3+ times move here permanently -->

_No crystallized rules yet. They'll appear here as the skill matures._
