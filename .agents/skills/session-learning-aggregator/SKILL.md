---
name: session-learning-aggregator
description: Analyzes finished interaction sessions, extracts user preferences, effective patterns, and key takeaways, and updates existing agent skills or logs learned knowledge to improve future performance. Trigger this skill at the end of a session, when wrapping up a task, or when instructed to save learnings or update skills from session context.
---

# Session Learning Aggregator

Analyze completed interactions to capture actionable insights, user preferences, and procedural learnings, then update existing skills or document insights for future sessions.

## When to Use

- When a session or interaction wraps up or the user explicitly asks to extract session learnings.
- When key user preferences, domain knowledge, or repeated corrections emerge during a task.
- When an existing skill's instructions need refinement based on performance in the current session.

## Steps for Session End Analysis

1. **Review Session History:**
   - Identify explicit user preferences (e.g., preferred formatting, coding standards, specific constraints).
   - Identify procedural friction points (where initial responses required correction or iteration).
   - Identify novel solutions, effective patterns, or reusable workflows developed during the session.

2. **Filter & Distill Learnings:**
   - **Keep:** High-value, durable rules, domain-specific guidance, and generalized preferences.
   - **Discard:** One-off session details, transient values, specific filenames, or temporal references.

3. **Determine Target Action:**
   - **Update Existing Skill:** If the learning directly improves a specific skill, update that skill's `SKILL.md` or auxiliary resource files.
   - **Document Standalone Learnings:** If no specific skill applies, output the summarized insights in a structured, actionable format.

4. **Verify Quality:**
   - Ensure added instructions use concise, imperative language ("Do X", "Avoid Y") without cluttering the context window.

## Gotchas

- Avoid recording temporary variables, precise dates, or hardcoded environment details.
- Keep instructions focused on generalized patterns so future executions across different contexts remain flexible.
