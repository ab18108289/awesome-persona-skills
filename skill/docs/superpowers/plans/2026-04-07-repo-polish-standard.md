# Repo Polish Standard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bring the repository up to a more complete GitHub project standard by adding maintenance-facing repo files, contribution templates, and light documentation polish without changing the directory's content strategy.

**Architecture:** Keep the repository markdown-first and data-driven. Add only lightweight project infrastructure around the existing JSON-plus-PowerShell workflow so contributors can understand how to contribute, open clean issues, and submit PRs without introducing automation or process overhead that the project does not need yet.

**Tech Stack:** Markdown, JSON, YAML, PowerShell 5.1

---

## Task 1: Add baseline repository files

**Files:**
- Create: `LICENSE`
- Create: `.gitignore`
- Create: `CHANGELOG.md`

- [ ] Add a permissive open source license so reuse and contribution expectations are clear.
- [ ] Add a small `.gitignore` tailored to this repository's Windows and editor workflow.
- [ ] Add a changelog with an initial released state and an `Unreleased` section for future curation updates.

## Task 2: Add GitHub contribution templates

**Files:**
- Create: `.github/ISSUE_TEMPLATE/recommend-entry.yml`
- Create: `.github/ISSUE_TEMPLATE/config.yml`
- Create: `PULL_REQUEST_TEMPLATE.md`

- [ ] Add an issue template that collects the repository URL, suggested category, and objective notes for new entries.
- [ ] Disable blank GitHub issues so incoming recommendations follow the repo's data shape.
- [ ] Add a pull request template that reminds contributors to validate data and regenerate the README before submission.

## Task 3: Polish maintenance documentation

**Files:**
- Modify: `README.md`
- Modify: `CONTRIBUTING.md`
- Modify: `scripts/generate-readme.ps1`

- [ ] Add a compact maintenance section to the generated README that explains the JSON-first workflow and where contributors should start.
- [ ] Tighten contribution guidance so it references both Issue-based recommendations and PR-based direct edits.
- [ ] Keep the README polish inside the generator so future runs preserve the maintenance messaging.

## Task 4: Verify the repository state

**Files:**
- Test: `scripts/validate-skills.ps1`
- Test: `scripts/generate-readme.ps1`
- Test: `scripts/test-repo-tools.ps1`
- Test: `README.md`

- [ ] Regenerate the README from the current dataset and confirm the new maintenance section renders correctly.
- [ ] Run the repo smoke test to ensure template and documentation changes do not break the existing script workflow.
- [ ] Check diagnostics on edited files before calling the work complete.

## Self-Review

### Spec coverage

- The plan adds the standard repo files requested in the approved scope.
- The plan includes GitHub-native contributor intake via issue and PR templates.
- The plan keeps README polish generator-driven so documentation does not drift.
- The plan avoids adding automation, extra content seeding, or unrelated engineering overhead.

### Placeholder scan

- No `TODO`, `TBD`, or deferred implementation steps are required to execute this plan.

### Type consistency

- The contribution flow stays centered on `data/skills.json`, `scripts/validate-skills.ps1`, and `scripts/generate-readme.ps1`.
- The new GitHub templates collect fields that map cleanly onto the existing entry schema and category taxonomy.
