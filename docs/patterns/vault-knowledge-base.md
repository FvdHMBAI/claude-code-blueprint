# Pattern: Vault Knowledge Base

## Problem

AI assistants lose context between sessions. Every conversation starts from scratch. Past mistakes are repeated. Architecture decisions are relitigated. The same bugs are debugged from zero.

Documentation helps, but flat docs don't scale. With 100+ files, the AI can't read everything upfront. With 1,000+ files, even knowing which file to read becomes a challenge.

## Solution

Use an Obsidian vault as a structured knowledge base, indexed by a custom RAG (Retrieval-Augmented Generation) system. The AI searches the vault before every task, finding relevant context from past sessions, incidents, and decisions.

## Architecture

```
┌──────────────────────────────────────────────┐
│                 Obsidian Vault                 │
│                                               │
│  00-Dashboard/    Session notes, KPIs         │
│  01-Architecture/ ADRs, policies, schemas     │
│  02-Features/     Feature specs, domain models│
│  03-Known-Issues/ Bug database, post-mortems  │
│  04-Sessions/     Daily work logs             │
│  05-Tests/        Test results, coverage      │
│  06-Audit/        Security audits, compliance │
│  ...                                          │
└──────────────┬───────────────────────────────┘
               │
        ┌──────▼──────┐
        │  RAG Index   │
        │  (SQLite)    │
        │  Embeddings  │
        │  + BM25      │
        └──────┬──────┘
               │
        ┌──────▼──────┐
        │  MCP Server  │
        │  semantic_   │
        │  search()    │
        └──────┬──────┘
               │
        ┌──────▼──────┐
        │ Claude Code  │
        │ searches     │
        │ before every │
        │ task         │
        └─────────────┘
```

## Setting Up the Vault

### 1. Folder Structure

Organize by topic, not chronology:

```
vault/
├── architecture/     # How things work and why
├── known-issues/     # Bug database with symptoms and fixes
├── sessions/         # Daily work logs (auto-generated)
├── incidents/        # Post-mortems with root cause analysis
├── decisions/        # Architecture Decision Records (ADRs)
└── domain-models/    # Business logic documentation
```

### 2. Document Types

**Symptom Index** — A lookup table mapping symptoms to known causes:
```markdown
| Symptom | Cause | Fix |
|---------|-------|-----|
| 502 after deploy | Traefik routing stale | `docker restart proxy` |
| Login redirect loop | Cookie domain mismatch | Check NEXT_PUBLIC_URL |
```

**Post-Mortems** — What happened, why, and what changed:
```markdown
## Incident: [Title]
**Impact:** [Who was affected, for how long]
**Root Cause:** [Why it happened]
**Fix:** [What we did]
**Prevention:** [What we changed to prevent recurrence]
```

**Session Notes** — What was built, decided, or discovered today:
```markdown
## 2026-01-15: Feature X Implementation
- Built: [What was built, with file paths]
- Decided: [Architecture decisions made]
- Learned: [Surprises, gotchas, insights]
```

### 3. RAG System

Build a simple RAG server as a Model Context Protocol (MCP) server:

**Indexing:**
- Chunk markdown files (1000 chars, 200 char overlap)
- Generate embeddings (local model like `qwen3-embedding` via Ollama)
- Store in SQLite with full-text search (BM25) alongside vector search

**Searching:**
- Hybrid search: combine semantic similarity (embeddings) with keyword matching (BM25)
- Return top-N chunks with file paths and relevance scores
- Low-confidence results (score < 0.45) are filtered out

**Reindexing:**
- Run on a schedule (e.g., nightly at 03:30)
- After any vault write, trigger a reindex

## The Three-Step Search

Before every task, search the vault in three steps:

1. **Symptom Index** — Check the relevant app's symptom index for known issues
2. **Semantic Search** — Search the full vault for related context
3. **Domain Model** — Read the relevant app's domain model for business context

This takes ~2 seconds and prevents hours of rediscovery.

## What To Write Back

After every task, write back to the vault:

| Event | Document |
|-------|----------|
| Bug fixed | Update symptom index + add to known issues |
| Architecture decision | Create ADR |
| Incident resolved | Write post-mortem |
| Feature shipped | Session note with what changed |
| Surprise/gotcha | Add to relevant domain model |

## Benefits

- **Institutional memory** — Past sessions inform future ones
- **Faster debugging** — Symptom indexes turn 30-minute investigations into 30-second lookups
- **Decision consistency** — ADRs prevent relitigating settled questions
- **Onboarding** — New team members (human or AI) get up to speed from the vault
- **Audit trail** — Every decision, incident, and change is documented

## Scaling

| Vault Size | Search Time | Notes |
|-----------|-------------|-------|
| 100 files | ~100ms | No optimization needed |
| 1,000 files | ~300ms | Still fast |
| 10,000+ files | ~1-2s | Chunk-level indexing essential |

At 14,000+ files, hybrid search (embeddings + BM25) keeps results fast and relevant. Pure semantic search misses keyword-exact matches; pure BM25 misses conceptual relationships. The hybrid approach gets both.
