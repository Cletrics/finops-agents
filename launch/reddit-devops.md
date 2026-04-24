# r/devops post

**Subreddit:** r/devops
**Flair:** Open Source / Tools

**Title:**

> Cloud cost agent personas for Claude Code / Cursor / Copilot -- MIT, 34 agents, 6 playbooks

**Body:**

```
Sharing a repo we open-sourced: drop-in FinOps specialist personas for
any modern coding assistant. The goal is that when your devs ask the
LLM about cloud cost stuff -- "is this RDS oversized?", "rightsize this
k8s workload", "why did our NAT Gateway bill triple?" -- they get an
answer from a persona that actually knows the schema, the commitment
math, and the common failure patterns.

34 agents across AWS / GCP / Azure / Kubernetes / data-platforms /
governance / waste-detection. 6 named playbooks (Zombie NAT Gateway,
Snapshot Sprawl, Cross-AZ Chatterbox, Idle Load Balancer, Oversized
RDS, Untagged Spend Drift).

Installer drops the markdown into your tool's config directory. No
runtime, no network, no telemetry. MIT licensed. You can grep it,
fork it, edit it, add your company's conventions.

Works with: Claude Code, Cursor, Windsurf, Copilot, Aider, OpenCode,
Gemini CLI.

https://github.com/cletrics/finops-agents

Interested in hearing which ones you use, what's missing, and what
your team's convention is for invoking these vs a general-purpose
assistant.
```
