---
name: email-triage
description: Triage the user's Gmail inbox — sweep recent unread/important mail, categorize it, apply labels, flag what needs a reply, and draft (never send) responses. Use when the user asks to "triage my email", "go through my inbox", "what needs a reply", or invokes /email-triage. Do NOT send any email; drafts only.
---

# Email Triage

Sweep the inbox, sort it into action buckets, and prepare reply drafts. This skill is
read-mostly: it labels, archives obvious noise, and creates drafts. It never sends mail
and never deletes anything non-obvious without confirmation.

## Requirements

A Gmail integration must be available (Claude: the Gmail connector tools; Codex or other
agents: an equivalent Gmail MCP server or CLI such as `gmailctl`/`himalaya`). If no email
access is available, say so and stop — do not simulate results.

## Workflow

1. **Scope the sweep.** Default: unread + anything in the inbox from the last 3 days.
   If the user says "today" or "this week", adjust the query accordingly.
2. **Fetch threads** (batches of ~20). For each thread capture: sender, subject, date,
   whether the user is in To vs Cc, and a one-line gist.
3. **Bucket each thread:**
   - **Needs reply** — a human asked the user something directly (user in To, question or request present).
   - **Needs action, no reply** — invoices to pay, docs to review, calendar decisions.
   - **FYI** — user in Cc, or informational updates worth a skim.
   - **Noise** — newsletters, promotions, automated notifications with no action.
4. **Apply labels** matching the buckets (create `triage/needs-reply`, `triage/action`,
   `triage/fyi` if missing). Archive **Noise** only if the user has previously said to;
   otherwise just label it.
5. **Draft replies** for every **Needs reply** thread: short, plain, in the user's voice
   (match their prior replies in the thread for tone and sign-off). Save as Gmail drafts.
   NEVER send.
6. **Report** in one compact summary: counts per bucket, a table of Needs-reply threads
   (sender, subject, draft status), and anything time-sensitive at the top.

## Hard rules

- Never send email. Drafts only.
- Never delete or mark-as-spam without explicit instruction in the current conversation.
- Never label or open threads matching obviously sensitive queries the user excluded.
- If a thread is ambiguous between buckets, prefer the higher-attention bucket.
