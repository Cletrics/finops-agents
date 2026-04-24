# r/FinOps post

**Subreddit:** r/FinOps
**Flair:** Tools / Resources (pick what's active at post time)

**Title:**

> [Open source] 34 FinOps agent personas + 6 named playbooks for Claude Code, Cursor, Copilot, Windsurf, Aider

**Body:**

```
Hey FinOps crew --

Sharing a repo we just opened up: cletrics/finops-agents on GitHub.

It's a library of 34 specialist personas for coding assistants. The
idea is: instead of asking a generic LLM "help me analyze my CUR", you
invoke the `AWS Cost Explorer Analyst` persona which already knows CUR
2.0 columns, Cost Categories, typical allocation pitfalls, and what a
good root-cause narrative looks like for a spend increase.

Categories:
- cloud-cost (AWS / GCP / Azure / multi-cloud / anomalies / forecasts)
- commitments (Savings Plans, RIs, CUDs, EDPs)
- kubernetes (OpenCost/Kubecost, rightsizing, Karpenter tuning)
- data-platforms (CUR/FOCUS ingestion, warehouse modeling)
- governance (showback, tag hygiene, maturity assessments)
- waste-detection (idle hunters, zombie NAT, snapshot gardening)
- specialized (ML/inference, serverless, spot)

Plus 6 named-pattern playbooks:
- Zombie NAT Gateway
- Snapshot Sprawl
- Cross-AZ Chatterbox
- Idle Load Balancer
- Oversized RDS
- Untagged Spend Drift

Why markdown files and not a SaaS? Because prompts are portable and
transparent. You can read exactly what each agent is told to do, fork
it, adjust it for your org's conventions, and share improvements back.

MIT license. Vendor-neutral where possible. No runtime. Works with
Claude Code, Cursor, Windsurf, Copilot, Aider, OpenCode, Gemini CLI.

PRs very welcome, especially:
- New regional-specific playbooks (Azure enrollment weirdness, GCP
  folder hierarchies, the specific way your CSP's billing export breaks)
- Localizations
- Agents we missed (Snowflake cost? Databricks? cost attribution
  for data engineering pipelines specifically?)

Repo: https://github.com/cletrics/finops-agents
Happy to answer anything.
```

**Engagement plan:**
- Respond to every comment for first 24 hours
- If someone suggests an agent -- open an issue on the repo in the comment
- If someone says "we already have X" -- ask what works / doesn't about it
