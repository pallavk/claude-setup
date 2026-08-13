---
name: email-triage
description: Triage the user's Gmail inboxes using the gog CLI — sweep recent unread/important mail across personal and work accounts, categorize it, apply labels, flag what needs a reply, and draft (never send) responses. Use when the user asks to "triage my email", "go through my inbox", "what needs a reply", or invokes /email-triage. Do NOT send any email; drafts only.
---

# Email Triage (gog CLI)

Sweep the inbox(es), sort into action buckets, and prepare reply drafts. This skill is
read-mostly: it labels, and creates drafts. It never sends mail and never deletes
anything without explicit instruction.

## Tooling: gog

Primary tool is the `gog` CLI (Google Workspace CLI, https://github.com/openclaw/gogcli).
Check `command -v gog` first. If gog is missing, fall back to a Gmail MCP connector if
one is available; if neither exists, say so and stop — do not simulate results.

### Accounts

The user maintains multiple accounts. Conventions in this setup:

- **Personal (default):** plain `gog …` (default account, or `GOG_ACCOUNT` env)
- **Work:** `gog --account work …` (account alias `work`; shell alias `gog-work`)
- List accounts: `gog auth list --check`

Unless the user names an account, triage **all** configured accounts and keep results
clearly separated per account in the report.

### Useful commands

```bash
gog gmail search 'in:inbox is:unread newer_than:3d' --json   # sweep query
gog gmail thread get <threadId> --json                        # read a thread
gog gmail labels list --json                                  # existing labels
gog gmail labels create 'triage/needs-reply'                  # create label
gog gmail thread modify <threadId> --add-label 'triage/needs-reply'
gog gmail drafts create --to <addr> --subject <subj> --body-file <file> --thread <threadId>
```

Prefer `--json` output and parse with `jq`. Run each command per account
(`gog` vs `gog --account work`). Flags can drift between gog versions — if a
command errors, check `gog gmail --help` rather than guessing.

## Workflow

1. **Scope the sweep.** Default query: `in:inbox is:unread newer_than:3d`.
   Adjust if the user says "today" / "this week".
2. **Fetch threads** per account. For each: sender, subject, date, To vs Cc,
   one-line gist (fetch thread bodies only for threads that look actionable).
3. **Bucket each thread:**
   - **Needs reply** — a human asked the user something directly (user in To, question or request present).
   - **Needs action, no reply** — invoices, docs to review, calendar decisions.
   - **FYI** — user in Cc, or informational updates worth a skim.
   - **Noise** — newsletters, promotions, automated notifications with no action.
4. **Apply labels** `triage/needs-reply`, `triage/action`, `triage/fyi` (create if
   missing, per account). Label Noise but do not archive unless previously told to.
5. **Draft replies** for every **Needs reply** thread using
   `gog gmail drafts create` on the same thread, from the matching account.
   Short, plain, in the user's voice (match their prior replies in the thread).
   NEVER send.
6. **Report** one compact summary, grouped by account: counts per bucket, a table of
   Needs-reply threads (sender, subject, draft created?), time-sensitive items on top.

## Hard rules

- Never send email (`gog gmail send` is forbidden in this skill). Drafts only.
- Never delete, archive-by-default, or mark-as-spam without explicit instruction in
  the current conversation.
- Never reply from the wrong account: drafts for work threads come from the work
  account, personal from personal.
- If a thread is ambiguous between buckets, prefer the higher-attention bucket.
