# Pattern: Model Routing

## Problem

Using the most powerful model for every task is wasteful. A simple file read doesn't need Opus. A `git status` check doesn't need Sonnet. But a security review absolutely needs the best model available.

Most setups use one model for everything. This costs more, runs slower, and doesn't actually improve quality for simple tasks.

## Solution

Route each task to the appropriate model based on complexity. Think of it like Cursor's "Auto" mode, but with explicit rules you control.

## The Routing Table

| Complexity | Model | When to Use |
|------------|-------|-------------|
| **Simple** | Haiku | File reads, grep, status checks, formatting, simple lookups, data extraction |
| **Standard** | Sonnet | Feature building, bug fixes, code review, content writing, test creation |
| **Complex** | Opus | Architecture decisions, security review, complex debugging, brainstorming, cross-system analysis |

## Decision Framework

Ask yourself: **"What's the cost of getting this wrong?"**

- Low cost → Haiku (fast, cheap, good enough)
- Medium cost → Sonnet (reliable, covers 80% of tasks)
- High cost → Opus (maximum reasoning, catches subtle issues)

## Applying to Subagents

When spawning subagents, set the model explicitly:

```javascript
// Simple lookup — Haiku
Agent({
  name: "check-status",
  model: "haiku",
  prompt: "Check if the Docker container is running"
})

// Standard feature work — Sonnet
Agent({
  name: "implement-feature",
  model: "sonnet",
  prompt: "Add pagination to the /api/users endpoint"
})

// Architecture review — Opus
Agent({
  name: "review-architecture",
  model: "opus",
  prompt: "Review this migration for safety under concurrent writes"
})
```

## Applying to Workflows

In workflow scripts, use the `effort` parameter:

| Task Type | Effort | Model |
|-----------|--------|-------|
| Mechanical implementation (clear spec, 1-2 files) | `low` | Haiku/Sonnet |
| Standard feature (multiple files, tests) | `medium` | Sonnet |
| Complex integration, debugging | `high` | Sonnet/Opus |
| Architecture, review, verification | `xhigh` | Opus |

## Agent Role Mapping

Map agent roles to models based on what they do:

| Role | Model | Reasoning |
|------|-------|-----------|
| Data analyst | Haiku | Structured lookups, no judgment calls |
| Quality reviewer | Sonnet | Rule-based checking, clear criteria |
| Content writer | Sonnet | Creative but constrained by brand guidelines |
| Lead developer | Opus | Full codebase context, architectural judgment |
| Security reviewer | Opus | Adversarial thinking, must catch subtle flaws |
| Architecture reviewer | Opus | Cross-system reasoning, broad context |

## Default to Sonnet

When in doubt, use Sonnet. It handles ~80% of tasks well. Only escalate to Opus when:
- The task involves security
- The task requires understanding multiple systems
- The task involves architectural judgment
- Getting it wrong would cause significant damage

Only drop to Haiku when:
- The task is purely mechanical
- The output is easily verifiable
- There's no judgment involved

## Cost Impact

In practice, this routing reduces costs by 60%+ compared to using Opus for everything, while maintaining the same quality for tasks that matter.

| Without Routing | With Routing |
|----------------|--------------|
| 100% Opus | ~10% Opus, ~70% Sonnet, ~20% Haiku |
| ~$X/session | ~$0.4X/session |
| Same speed for all tasks | Fast tasks are fast, hard tasks get full power |

## Anti-Patterns

- **Using Haiku for code review** — It misses subtle issues. Code review needs at least Sonnet.
- **Using Opus for data extraction** — Expensive and no better than Haiku for structured lookups.
- **Changing models mid-task** — If you started with Sonnet and it's struggling, escalate to Opus with fresh context rather than switching mid-conversation.
- **Not specifying model** — When you omit the model parameter, the subagent inherits the parent's model. This is usually fine but can lead to Opus being used for simple subtasks.
