# Self-Improving Skills — The Learnings Loop

## The Problem

AI assistants start every session from scratch. They make the same mistakes, rediscover the same solutions, and forget what worked yesterday. Prompt engineering helps, but static rules can't capture everything — especially the messy, context-dependent patterns that emerge from real usage.

## The Solution

Skills that improve themselves through a structured learning cycle:

```
Session 1: Skill runs → encounters issue → records learning
Session 2: Skill reads learnings → avoids issue → increments Runs counter
Session 3: Same learning helps again → Runs = 3, Score = 4 → CRYSTALLIZE
Session 4: Learning is now a permanent rule in SKILL.md
```

## How It Works

### 1. Before Execution
The skill reads its `learnings.md` file. Each learning is a structured entry with a rule, a score (1-5), and a Runs counter.

### 2. During Execution
When a learning applies, the AI follows the rule and notes that it helped.

### 3. After Execution
Three things happen:
- **Runs tracking:** Increment the counter for each learning that helped
- **New learnings:** Add entries for genuinely new patterns (not duplicates)
- **Crystallization:** Promote learnings with Score >= 4 AND Runs >= 3

### 4. Crystallization
When a learning proves itself across 3+ different contexts, it graduates from `learnings.md` to `SKILL.md` as a permanent rule. The original entry stays in `learnings.md` marked as `CRYSTALLIZED` for audit trail.

## Why It Works

- **Runs counter prevents premature crystallization.** A learning that scored 5 once might be a fluke. A learning that helped 3 times across different sessions is a pattern.
- **Noise filter keeps signal-to-noise ratio high.** One-off issues, already-hooked rules, and too-generic advice get filtered out. Only recurring patterns survive.
- **Crystallization makes rules permanent.** Once in SKILL.md, the rule is part of the skill's DNA. It doesn't depend on the AI "remembering" to check learnings.

## The Noise Problem

Without filtering, learnings files accumulate junk. In practice, roughly 40-50% of auto-generated learnings are noise. The filter criteria:

| Don't Add | Why |
|-----------|-----|
| One-off issues | No pattern to learn from |
| Context-dependent rules | Only applies to one ticket/feature |
| Hook-enforced rules | Already blocked at the tool level |
| Generic advice | "Write good tests" teaches nothing |

## File Structure

```
skills/your-skill/
├── SKILL.md         # Skill definition + crystallized rules
└── learnings.md     # Active learnings with scores and run counts
```

## Getting Started

1. Copy `SKILL.md` and `learnings.md` to your skill directory
2. Replace the example skill logic with your actual workflow
3. Add the "Before/After Execution" steps to your skill
4. Run the skill normally — learnings accumulate automatically
5. After ~10 sessions, check what crystallized

## Credits

The crystallization concept draws from the [Shmayro Singularity-Claude](https://github.com/shmayro/singularity-claude) 4-Stage Skill Lifecycle pattern. The noise filter percentages (46% noise rate) are from real-world usage data.
