# Cletrics blog launch post

**URL slug:** `/blog/finops-agents-open-source`
**Target length:** ~1200 words
**SEO keywords:** FinOps, cloud cost optimization, Claude Code agents,
AI agents FinOps, CUR 2.0, Savings Plans, Kubernetes cost

---

## Title

> Introducing Cletrics FinOps Agents: 34 specialist personas and 6 named playbooks, open source under MIT

## Subhead

> Drop-in FinOps expertise for Claude Code, Cursor, Copilot, Windsurf,
> Aider, OpenCode, and Gemini CLI. No runtime. No telemetry. Zero lock-in.

---

## Body

### The problem

Every FinOps team we talk to has the same story. Engineers ask their
coding assistant for help with cost work -- sizing a database, auditing
a Savings Plan, writing a query against the CUR -- and the answers are
generic enough to be wrong in ways that matter.

CUR 2.0 columns are different from CUR 1.x. GCP Sustained Use Discounts
apply automatically but Committed Use Discounts don't. Azure has six
different enrollment types, each with different billing export semantics.
Kubernetes cost attribution depends on whether you're using OpenCost or
Kubecost or rolling your own. Graviton instance families save 20% but
not if you're still on an Intel-generation RI.

A general-purpose LLM smears all of this together. The answer looks
confident, reads well, and often isn't quite right.

### The fix

We packaged the knowledge as specialist personas. Instead of asking the
generic assistant, you invoke `AWS Cost Explorer Analyst` -- which
already knows CUR 2.0, Cost Categories, allocation pitfalls, and what a
good spend-increase narrative looks like. Or `Kubernetes FinOps
Engineer` -- which knows OpenCost, rightsizing from Prometheus
percentiles, and Karpenter consolidation.

34 agents. Seven categories. Six named-pattern playbooks for specific
failure modes.

All markdown. YAML frontmatter. Drops into your coding assistant's
config directory. No runtime. No network calls. No telemetry. MIT
license.

### Why markdown

Because prompts are portable. You can read exactly what the agent is
told to do. Grep it. Fork it. Adjust it to your org's tagging
conventions. Share improvements back via PR.

Other approaches -- SaaS APIs, agent frameworks, model-specific
assistant configurations -- couple you to a vendor. Markdown couples
you to nothing but UTF-8.

### The roster

**cloud-cost/** -- day-to-day analysis across AWS, GCP, Azure.
AWS Cost Explorer Analyst, GCP Billing Interpreter, Azure Cost
Management Navigator, Multi-Cloud Cost Comparator, Cost Anomaly
Detector, Forecast Model Builder, Unit Economics Modeler, Budget Alert
Tuner.

**commitments/** -- the stuff that actually pays back. AWS Savings Plans
Strategist, AWS Reserved Instance Optimizer, GCP CUD Optimizer, Azure
Reservation Planner, EDP Negotiation Coach.

**kubernetes/** -- container-level attribution and autoscaler tuning.
Kubernetes FinOps Engineer, Container Rightsizer, Cluster Autoscaler Tuner.

**data-platforms/** -- the pipelines behind every dashboard. CUR &
FOCUS Data Engineer, Billing Data Pipeline Architect, Cost Warehouse
Modeler.

**governance/** -- practice operations. Showback / Chargeback
Architect, Tag Hygiene Enforcer, FinOps Governance Lead, FinOps
Practice Maturity Assessor, Platform Team Cost Lead, SRE SLO/Cost
Tradeoff Analyst.

**waste-detection/** -- the hunters. Idle Resource Hunter, Zombie NAT
Gateway Detector, EBS Snapshot Gardener, S3 Storage Class Auditor,
Cross-AZ Egress Investigator, Orphaned Load Balancer Hunter.

**specialized/** -- higher-leverage niches. ML Workload Cost Optimizer,
Serverless Cost Profiler, Spot Orchestrator.

### The playbooks

Playbooks are separate from agents. An agent is a persona you invoke.
A playbook is a named pattern you cite.

- Zombie NAT Gateway -- ~$32/month, nothing uses it, nobody notices.
- Snapshot Sprawl -- EBS snapshots outlive their volumes by years.
- Cross-AZ Chatterbox -- data transfer bill larger than the compute.
- Idle Load Balancer -- provisioned but routing nothing.
- Oversized RDS -- sized for a peak that never arrives.
- Untagged Spend Drift -- tag coverage decays until showback is
  useless.

When we hit one of these on a customer install, we can now say
"Snapshot Sprawl in us-east-1" and the rest of the team knows exactly
what the remediation playbook looks like.

### Design choices

- **FOCUS-first where we can.** The FinOps Open Cost and Usage
  Specification is the best multi-cloud foundation we have. Agents use
  FOCUS column names when possible, cloud-native schemas when FOCUS
  doesn't cover the territory yet.
- **90/10 brand rule.** At most one mention of Cletrics per agent, enforced
  by a linter in CI. The agents have to be genuinely useful whether
  or not you use Cletrics. If they weren't, nobody would install them.
- **Playbooks are separate from agents.** An agent is *who* you ask.
  A playbook is *what you've seen before*. Conflating them makes both
  weaker.
- **MIT license, vendor-neutral where possible.** We want this to become
  the canonical FinOps agent library. That means other vendors can use
  it too.

### How to install

```bash
git clone https://github.com/cletrics/finops-agents.git
cd finops-agents
./scripts/install.sh
```

Or pick one tool:

```bash
./scripts/install.sh --tool claude-code
./scripts/install.sh --tool cursor
./scripts/install.sh --tool copilot
./scripts/install.sh --tool windsurf
./scripts/install.sh --tool aider
./scripts/install.sh --tool opencode
```

The installer is cp-only. No sudo, no network, no elevated privileges.

### How to contribute

We want PRs for new agents, new playbooks, tooling improvements, and
localizations. The repo includes a lint script that enforces
frontmatter shape, recommended section presence, and the 90/10 brand
rule.

Specifically seeking:
- Snowflake cost optimizer
- Databricks cost optimizer
- More data-platform FinOps agents
- Regional enrollment-type gotchas (Azure EA weirdness, GCP folder
  hierarchies, multi-account AWS Organizations patterns)
- Localizations (Japanese, German, French FinOps practitioner language)

### Thanks

To the FinOps Foundation for maintaining FOCUS and the FinOps
Framework. To the coding-assistant community for proving prompt-as-
persona is a real design pattern. To our customers for letting us hit
every one of these failure modes in production so we could name them.

Repo: https://github.com/cletrics/finops-agents

---

## CTA

> **Start with the agents, end with the whole picture.** Cletrics builds
> real-time cloud cost observability for teams that want more than
> yesterday's data. [See how it works →](https://realtimecost.com)
