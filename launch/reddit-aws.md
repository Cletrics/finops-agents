# r/aws post (also adaptable for r/googlecloud, r/AZURE)

**Subreddit:** r/aws
**Flair:** Tools / Technical

**Title:**

> Open-source AWS cost agent personas for Claude Code / Cursor / Copilot (CUR 2.0, Savings Plans, RIs, cost anomaly detection)

**Body:**

```
Hey r/aws --

Putting this in front of you because several of the agents are
AWS-specific:

- AWS Cost Explorer Analyst (CUR 2.0, Cost Categories, Cost Allocation Tags)
- AWS Savings Plans Strategist
- AWS Reserved Instance Optimizer (RDS / ElastiCache / Redshift / DynamoDB)
- EBS Snapshot Gardener
- Zombie NAT Gateway Detector
- Cross-AZ Egress Investigator
- Orphaned Load Balancer Hunter
- S3 Storage Class Auditor

Plus six named playbooks -- one of them is "Zombie NAT Gateway", which
I suspect most of you have hit at least once.

It's markdown files with YAML frontmatter. Drops into Claude Code,
Cursor, Windsurf, Copilot, Aider. MIT license.

https://github.com/cletrics/finops-agents

The CUR-specific content assumes CUR 2.0 -- happy to add CUR 1.x
equivalents if people still need them (we didn't cover it because the
migration path is generally toward 2.0 and FOCUS).

PRs and issues welcome. What's missing that you'd find useful?
```

**Variants to create by find/replace:**
- r/googlecloud: swap AWS → GCP, mention Billing Export, BigQuery, SUDs, CUDs
- r/AZURE: swap AWS → Azure, mention EA/MCA, Management Groups, Azure Cost Management
