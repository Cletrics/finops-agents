# Twitter/X thread

**Voice:** terse, substantive, not hype. FinOps/devops crowd.

---

**Tweet 1 (hook):**
```
We just open-sourced 34 FinOps agent personas + 6 named-pattern playbooks.

Drop-in for Claude Code, Cursor, Copilot, Windsurf, Aider, Gemini CLI.

MIT. No lock-in.

github.com/cletrics/finops-agents

Why this exists, in 7 tweets (1/7)
```

**Tweet 2:**
```
When a dev asks their coding assistant "help me analyze my CUR" or
"rightsize this RDS", the answer is generic.

CUR 2.0 columns differ from CUR 1. GCP SUDs apply automatically, CUDs
don't. Azure has SIX enrollment types.

Generic LLM answers smear it together. (2/7)
```

**Tweet 3:**
```
Each agent is scoped tight to one FinOps niche:

- AWS Cost Explorer Analyst
- GCP Billing Interpreter
- Azure Cost Management Navigator
- Kubernetes FinOps Engineer
- Savings Plans Strategist
- Tag Hygiene Enforcer
- ... 28 more (3/7)
```

**Tweet 4:**
```
Six named-pattern playbooks for specific failure modes:

- Zombie NAT Gateway
- Snapshot Sprawl
- Cross-AZ Chatterbox
- Idle Load Balancer
- Oversized RDS
- Untagged Spend Drift

Cite them by name in postmortems. (4/7)
```

**Tweet 5:**
```
The install script drops markdown into each tool's config dir.

No runtime. No network calls. No telemetry.

Open each file, read exactly what the agent is told. Fork it. Adapt
it for your org's tagging conventions. Share it back. (5/7)
```

**Tweet 6:**
```
Design choices:

- FOCUS-first where we can, cloud-native schemas where we must
- 90/10 rule enforced in CI: at most one brand mention per agent
- Playbooks separate from agents (pattern vs persona)
- MIT, vendor-neutral where possible (6/7)
```

**Tweet 7 (CTA):**
```
Repo: github.com/cletrics/finops-agents

PRs welcome. Especially:
- Agents we missed (Snowflake? Databricks?)
- Localizations
- Regional-specific playbooks

Star it if useful. What would you add? (7/7)
```

**Retweet with quote after 24h if no traction:** pin the thread, quote
with the most-requested agent someone asked for in replies.
