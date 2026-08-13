---
name: weekly-review
description: Run the user's end-of-week review — recap the week's calendar, email threads, and git activity, surface loose ends, and draft next week's priorities. Use when the user asks for a weekly review, week wrap-up, "what did I do this week", or invokes /weekly-review.
---

# Weekly Review

A wrap-up counterpart to the morning brief: look back over the week, then set up the
next one. Gather from whatever sources are actually connected — skip gracefully and say
which sources were unavailable rather than inventing content.

## Sources (use what's available)

- **Calendar** — this week's meetings; next week's committed blocks.
- **Email** — threads the user replied to (work themes) and threads still awaiting a
  reply from the user (loose ends).
- **Git/GitHub** — commits, PRs opened/merged/reviewed this week across accessible repos.
- **Task/notes tools** — open items, if a task tool or notes connector exists.

## Workflow

1. Determine the week window (Mon–today, unless the user names a range).
2. Pull each available source in parallel. Cap email at ~50 threads and summarize.
3. Build the review with these sections, keeping the whole thing skimmable:
   - **Highlights** — 3–5 things that actually moved (shipped, decided, resolved).
   - **Where the time went** — meeting hours vs. focus time; heaviest recurring themes.
   - **Loose ends** — unanswered emails, open PRs, meetings with no follow-up, tasks
     touched but not finished.
   - **Next week** — already-committed calendar items, plus a proposed top-3 priority
     list inferred from loose ends. Mark the proposals clearly as suggestions.
4. Deliver as clean markdown in chat. If the user asks for it as a document or page,
   produce that format; do not create files or artifacts unprompted.

## Rules

- Read-only: never modify calendar events, send email, or close tasks during a review.
- Loose ends must cite their source (thread subject, PR number, event title) so the
  user can act on them directly.
- If every source is unavailable, say so and offer to run on whatever the user pastes in.
