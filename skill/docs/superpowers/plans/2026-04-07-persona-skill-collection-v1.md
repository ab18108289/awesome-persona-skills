# Persona Skill Collection V1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the repository into a GitHub-native directory with a directory-first README, a structured JSON source of truth, and lightweight scripts for validation and README generation.

**Architecture:** Keep the repository simple and markdown-first. `data/skills.json` becomes the single source of truth for entries, `scripts/generate-readme.ps1` renders the curated sections in `README.md`, and `scripts/validate-skills.ps1` enforces the schema and duplicate rules so the directory can scale without drifting.

**Tech Stack:** Markdown, JSON, PowerShell 5.1

---

## Task 1: Expand the source-of-truth schema

**Files:**
- Modify: `data/skills.json`
- Modify: `CONTRIBUTING.md`

- [ ] Add `entry_kind` and `featured` to the JSON schema while keeping the existing category taxonomy.
- [ ] Replace the placeholder entry with the first balanced seed set covering all eight categories.
- [ ] Update the contribution guide so contributors know when to use `skill`, `persona_repo`, and `watchlist`.

## Task 2: Rebuild the README as a directory homepage

**Files:**
- Modify: `README.md`

- [ ] Rewrite the intro so it describes the repo as a directory, not a generic project skeleton.
- [ ] Move navigation and scope rules above the featured section.
- [ ] Keep featured entries small, then make the category directory the main body.
- [ ] Add explicit notes that the repository is Chinese-community-first with a small number of globally famous persona projects as supplements.

## Task 3: Add script-backed maintenance

**Files:**
- Modify: `scripts/validate-skills.ps1`
- Create: `scripts/generate-readme.ps1`

- [ ] Extend validation to cover the new fields, URL shape, duplicate names, empty tags, and supported status values.
- [ ] Add a README generator that groups entries by category, surfaces featured items, and renders the directory body from `data/skills.json`.
- [ ] Keep the generated output deterministic so future updates stay readable.

## Task 4: Verify the repository state

**Files:**
- Test: `data/skills.json`
- Test: `README.md`
- Test: `scripts/validate-skills.ps1`
- Test: `scripts/generate-readme.ps1`

- [ ] Run the validator against the seeded dataset and confirm it passes.
- [ ] Run the README generator and confirm the homepage updates from JSON.
- [ ] Re-run validation after generation and inspect the final README structure.

## Self-Review

### Spec coverage

- The README becomes directory-first instead of recommendation-first.
- The dataset supports both strict skills and broader persona repos.
- The scope stays Chinese-community-first while allowing a small number of famous global persona examples.
- The maintenance flow is JSON-first, then validate, then generate.

### Placeholder scan

- No `TODO`, `TBD`, or deferred implementation notes are required to execute V1.

### Type consistency

- `entry_kind` values are `skill`, `persona_repo`, and `watchlist`.
- `featured` is boolean.
- Category names stay aligned with the current eight-section taxonomy.
