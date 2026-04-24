# LinkedIn post (Jeff's personal account)

**Hook format:** First 3 lines visible above "see more". Lead with the
concrete thing, not a story.

**Post:**

```
We open-sourced 34 FinOps agent personas and 6 named playbooks today.

cletrics/finops-agents on GitHub. MIT. Zero lock-in.

Works with Claude Code, Cursor, Copilot, Windsurf, Aider, OpenCode,
and Gemini CLI.

The pitch in one paragraph: when your team asks their coding
assistant "help me size this RDS" or "is our Savings Plan coverage
any good?", the generic answer is usually subtly wrong. These 34
personas know the schema, the commitment math, the common failure
patterns, and the questions a senior FinOps practitioner would ask
before giving you an answer.

Categories:
-> cloud-cost (AWS / GCP / Azure / multi-cloud)
-> commitments (Savings Plans, RIs, CUDs, EDP negotiation)
-> kubernetes (OpenCost, rightsizing, Karpenter tuning)
-> data-platforms (CUR/FOCUS ingestion, warehouse modeling)
-> governance (showback, tag hygiene, maturity)
-> waste-detection (idle hunters, zombie NAT, snapshot gardening)
-> specialized (ML, serverless, spot)

Plus 6 named failure patterns: Zombie NAT Gateway, Snapshot Sprawl,
Cross-AZ Chatterbox, Idle Load Balancer, Oversized RDS, Untagged
Spend Drift.

Markdown files with YAML frontmatter. The install script drops them
into each tool's config directory. No runtime, no telemetry, no
network calls. Read them, fork them, adapt them for your org.

We'd love PRs -- especially agents we missed (Snowflake? Databricks?
more FinOps-for-Data content?), localizations, and regional-specific
playbooks. Link in comments.

#FinOps #CloudCost #DevOps #AI
```

**First comment (put the link here, not in the post body -- LinkedIn
algo penalizes external links in main post):**

> https://github.com/cletrics/finops-agents

**Engagement:**
- Tag FinOps Foundation (if you're connected) in a comment 30-60 min
  after posting
- Reply to every comment for first 48h
