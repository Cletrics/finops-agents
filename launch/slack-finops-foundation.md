# FinOps Foundation Slack

**Channel:** `#community` first (or whatever the intros-and-shares
channel is at post time). If appropriate, cross-post in `#technical`
or `#automation`.

**Check first:**
- Posting rules for the channel (FinOps Foundation Slack has a pinned
  message in most channels about self-promotion)
- Tag any FinOps Foundation Ambassadors you know personally

**Message:**

```
Hey everyone -- wanted to share something we just open-sourced.

cletrics/finops-agents is a library of 34 specialist AI agent
personas and 6 named-pattern playbooks, designed to drop into any
modern coding assistant (Claude Code, Cursor, Copilot, Windsurf,
Aider, Gemini CLI, OpenCode).

The motivation: when a practitioner asks an LLM "help me analyze my
CUR" or "is this commitment coverage any good?", the answer is
usually generic enough to be subtly wrong. Each persona in this repo
is scoped tightly to one FinOps niche (AWS CUR, GCP billing export,
Azure MCA, Kubernetes attribution, Savings Plans, tag hygiene, etc)
and loaded with the schema + gotchas + common failure modes.

Categories: cloud-cost, commitments, kubernetes, data-platforms,
governance, waste-detection, specialized.

Playbooks are named-pattern writeups for specific failure modes --
Zombie NAT Gateway, Snapshot Sprawl, Cross-AZ Chatterbox,
Idle Load Balancer, Oversized RDS, Untagged Spend Drift.

MIT, vendor-neutral where possible. No runtime. Not tied to any
specific FinOps platform.

Repo: https://github.com/cletrics/finops-agents

Would love feedback from anyone here, and especially PRs for:
- Regional-specific failure modes we missed
- New agents (Snowflake? Databricks? FinOps for Data?)
- Improvements to the FOCUS-related data-platform agents
- Localizations

Happy to talk through the design choices on a call, async, or
right here.
```
