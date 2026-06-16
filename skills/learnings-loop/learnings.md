# Learnings — Example Skill

This file tracks what the skill learns across sessions. Each entry follows the format below.

## Format

```markdown
## YYYY-MM-DD: [Short Title]
**Context:** What was the task
**Insight:** What we learned
**Rule:** The derived rule for future sessions
**Score:** 1-5 (how useful has this been so far?)
**Runs:** How many times has this rule helped? (increment each session it applies)
**Status:** ACTIVE | CRYSTALLIZED → SKILL.md
```

## Lifecycle

1. **New** — First observed. Score 1, Runs 0.
2. **Validated** — Applied in a different context and helped. Score goes up, Runs increments.
3. **Crystallized** — Score >= 4, Runs >= 3. Moves to SKILL.md as a permanent rule.
4. **Archived** — Proved to be noise (too context-specific, already covered by a hook, too generic). Kept for audit trail but not applied.

## Noise Filter

Do NOT add learnings that are:
- One-off issues (single occurrence, no pattern)
- Context-dependent (only relevant to a specific ticket/feature)
- Already enforced by a hook (redundant)
- Too generic ("write good code", "test thoroughly")

Only add **recurring patterns** and **process improvements**.

---

## Example Entries

## 2026-01-15: Database column name mismatch
**Context:** Generated a query assuming `first_name` column existed
**Insight:** The profiles table uses `full_name`, not `first_name`/`last_name`
**Rule:** Always check column names with `\d table_name` before writing queries
**Score:** 5
**Runs:** 12
**Status:** CRYSTALLIZED → SKILL.md

## 2026-02-03: Build cache invalidation after dependency change
**Context:** Added a new npm package but Docker build used cached layer
**Insight:** When package.json changes, the Docker layer cache must be invalidated
**Rule:** After adding/removing dependencies, verify the Docker build picks them up
**Score:** 3
**Runs:** 2
**Status:** ACTIVE
