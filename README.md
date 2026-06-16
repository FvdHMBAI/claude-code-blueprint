# Claude Code Blueprint

**How a solo founder runs 13+ SaaS products with AI-powered development.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Built%20with-Claude%20Code-blueviolet)](https://claude.ai/code)
[![Skills](https://img.shields.io/badge/Skills-52-green)](skills/)
[![Hooks](https://img.shields.io/badge/Hook%20Guards-131-orange)](hooks/)

---

## What This Is

This repository shares the patterns, guard rails, and automation strategies behind a production system where **one developer** ships and operates **13+ live SaaS applications** — with AI doing the heavy lifting.

It's not a framework. It's not a library. It's a **blueprint** — a set of battle-tested patterns for turning Claude Code from a code completion tool into an autonomous development partner.

### The Numbers

| Metric | Value |
|--------|-------|
| Live products (own domains) | 13+ |
| Claude Code skills | 52 |
| Hook guard scripts | 131 |
| Custom MCP servers | 4 |
| Knowledge base files | 14,000+ |
| Docker containers running | 137 |
| PostgreSQL databases | 20 |
| AI features in production | 32 |
| CI/CD workflows | 20 |
| Nightly autonomous agents | 18+ |

All on two Hetzner servers. Total infra cost: ~$65/month.

## Why This Exists

Most "AI coding" setups are a single CLAUDE.md with a few rules. That works for side projects. It doesn't work when you're running production systems with paying customers, GDPR compliance requirements, and zero tolerance for downtime.

This blueprint shows how to build **defense in depth** for AI-assisted development:

- **Hooks** that physically prevent dangerous operations (pushing to main, building from dirty git, exposing secrets)
- **Skills** that encode complex workflows so every execution follows the same quality standard
- **A knowledge base** that gives the AI institutional memory across sessions
- **Model routing** that uses the right model for the right task — not always the most expensive one

## What's Inside

```
claude-code-blueprint/
├── CLAUDE.md.template          # Annotated template for your project instructions
├── hooks/examples/
│   ├── pre-bash-dispatcher.sh  # Pattern: dispatch guards from a single entry point
│   ├── docker-build-guard.sh   # Guard: prevent builds from dirty git state
│   └── main-push-guard.sh      # Guard: block direct pushes to protected branches
├── skills/learnings-loop/
│   ├── SKILL.md                # Template: self-improving skill with learnings integration
│   ├── learnings.md            # Example learnings file with format docs
│   └── README.md               # Concept: skills that get better through usage
└── docs/patterns/
    ├── hook-dispatcher.md      # How to build a hook dispatcher with guard files
    ├── vault-knowledge-base.md # Using Obsidian + RAG as AI development memory
    └── model-routing.md        # Right model for the right task
```

## Quick Start

### 1. Copy the CLAUDE.md template

```bash
cp CLAUDE.md.template your-project/.claude/CLAUDE.md
```

Edit the `<!-- CUSTOMIZE -->` sections to match your project.

### 2. Set up hook guards

```bash
# Copy the dispatcher and example guards
cp hooks/examples/*.sh your-project/.claude/hooks/

# Configure in your Claude Code settings
# See docs/patterns/hook-dispatcher.md for details
```

### 3. Add a self-improving skill

```bash
cp -r skills/learnings-loop your-project/.claude/skills/my-skill
```

Edit `SKILL.md` to define your skill's behavior. The learnings loop tracks what works and crystallizes proven patterns into permanent rules.

### 4. Read the pattern docs

Start with [Hook Dispatcher](docs/patterns/hook-dispatcher.md), then [Knowledge Base](docs/patterns/vault-knowledge-base.md), then [Model Routing](docs/patterns/model-routing.md).

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                  Claude Code                     │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌───────────────┐  │
│  │  Skills   │  │  Hooks   │  │  MCP Servers  │  │
│  │ (52)      │  │ (131)    │  │ (4 custom)    │  │
│  └────┬─────┘  └────┬─────┘  └──────┬────────┘  │
│       │              │               │           │
│       ▼              ▼               ▼           │
│  ┌──────────────────────────────────────────┐    │
│  │           CLAUDE.md (Project Rules)       │    │
│  └──────────────────────────────────────────┘    │
│       │              │               │           │
└───────┼──────────────┼───────────────┼───────────┘
        │              │               │
        ▼              ▼               ▼
  ┌──────────┐  ┌──────────┐  ┌───────────────┐
  │ Obsidian  │  │  GitHub   │  │  Databases    │
  │ Vault     │  │  Actions  │  │  (Supabase)   │
  │ (14k+)    │  │  CI/CD    │  │  (20 DBs)     │
  └──────────┘  └──────────┘  └───────────────┘
```

### The Three Layers

**Layer 1 — Prevention (Hooks)**
Shell scripts that run before/after tool calls. They physically block dangerous operations: pushing to protected branches, building Docker images from uncommitted code, exposing secrets in output. You can't "convince" a hook to let you through — it's code, not a prompt.

**Layer 2 — Process (Skills)**
Reusable workflows for complex tasks. A deployment skill always runs the same checks. A debugging skill always follows the same diagnostic path. Skills encode institutional knowledge so quality doesn't depend on the AI "remembering" the right approach.

**Layer 3 — Memory (Knowledge Base)**
An Obsidian vault with 14,000+ files, indexed by a custom RAG system (semantic search + BM25 hybrid). The AI searches this before every task — past incidents, architecture decisions, known issues. Sessions build on sessions, not from scratch.

### Model Routing

Not every task needs the most powerful model:

| Complexity | Model | When |
|------------|-------|------|
| Simple | Haiku | File reads, status checks, formatting |
| Standard | Sonnet | Feature building, bug fixes, code review |
| Complex | Opus | Architecture decisions, security review, debugging |

This alone cuts costs by 60%+ while maintaining quality where it matters.

## Key Patterns

### Hook Dispatcher
Instead of configuring dozens of individual hooks, use a single dispatcher that reads guard files from a directory. Adding a new guard = adding a file. No config changes needed. [Full pattern →](docs/patterns/hook-dispatcher.md)

### Self-Improving Skills (Learnings Loop)
Skills track what works and what doesn't across sessions. When a pattern proves itself 3+ times, it "crystallizes" into a permanent rule in the skill definition. Skills literally get better the more you use them. [Full pattern →](skills/learnings-loop/README.md)

### Vault as AI Memory
An Obsidian vault + custom MCP server gives the AI searchable, persistent memory. Post-mortems, architecture decisions, known issues — all indexed and available before every task. [Full pattern →](docs/patterns/vault-knowledge-base.md)

### Branch Protection Without GitHub Enterprise
Hook guards that block pushes to main/master/production at the CLI level. Combined with Coolify auto-deploy from `develop`, this enforces `feature → develop → test → PR → main → prod` without paying for branch protection rules. [Full pattern →](hooks/examples/main-push-guard.sh)

## What This Is NOT

- **Not a framework** — There's nothing to `npm install`. These are patterns to adapt.
- **Not a prompt library** — CLAUDE.md is project-specific. The template shows structure, not content.
- **Not a magic wand** — This took months of iteration. Start with one hook, one skill, one pattern.

## Principles

1. **Defense in depth** — Don't trust prompts alone. Hooks enforce what rules request.
2. **Encode, don't remember** — If it matters, write it down. Skills > memory > hope.
3. **Right tool, right cost** — Haiku for lookups, Sonnet for features, Opus for architecture.
4. **Fail safe** — When a guard can't determine safety, it blocks. False positives > false negatives.
5. **Self-improving** — Track what works. Crystallize patterns. Delete what doesn't.

## Contributing

Found a pattern that works? Open a PR. The best contributions are:

- New guard patterns for common mistakes
- Skill templates for specific workflows
- Documentation of patterns you've discovered
- Bug fixes or improvements to existing examples

Please keep examples generic — no project-specific code, no secrets, no internal URLs.

## License

MIT License — see [LICENSE](LICENSE).

Built by [Frederik von der Heyden](https://frederikvonderheyden.de) with Claude Code.
