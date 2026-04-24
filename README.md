# Cletrics FinOps Agents

**The open-source reference library for cloud cost operations.** A curated set
of specialist AI agent personas and named-pattern playbooks that drop into
any modern coding assistant -- Claude Code, OpenAI Codex CLI, Gemini CLI,
GitHub Copilot, Cursor, Windsurf, Aider, and OpenCode -- plus ChatGPT Custom
GPTs, Claude Projects, and Gemini Gems on the web.

Built by [Cletrics](https://realtimecost.com) and the FinOps community.
MIT-licensed. Vendor-neutral where possible. Contributions welcome.

**Framework-aligned.** Every agent carries explicit
[FinOps Framework](https://www.finops.org/framework/) metadata
(Domain, Capability, Phase, Personas, Maturity entry point). Current
coverage: **13 of 22** canonical FCP Framework Capabilities. See
[`fcp-coverage.md`](./fcp-coverage.md) for the live matrix and roadmap
gaps, or run `./scripts/fcp-coverage.sh`.

---

## Why this exists

Cloud cost operations is a practice: tagging, allocation, forecasting,
commitment management, waste detection, unit economics, and the human
cadences that tie them together. It's also full of specialized knowledge --
CUR schema quirks, GCP SUD dynamics, Azure enrollment types, Kubernetes
attribution math -- that every team ends up re-learning from scratch.

This repo packages that knowledge as agent personas your coding assistant
can load on demand. Instead of "help me write a BigQuery query for GCP
billing," you ask the **GCP Billing Interpreter** agent, and it knows the
schema, the credit model, and the common gotchas before you type the first
line.

---

## Install

```bash
git clone https://github.com/cletrics/finops-agents.git
cd finops-agents

# Install for all detected tools
./scripts/install.sh

# Or pick one
./scripts/install.sh --tool claude-code
./scripts/install.sh --tool codex         # OpenAI Codex CLI
./scripts/install.sh --tool gemini-cli    # Gemini CLI (skill format)
./scripts/install.sh --tool copilot
./scripts/install.sh --tool cursor
./scripts/install.sh --tool windsurf
./scripts/install.sh --tool aider
./scripts/install.sh --tool opencode
./scripts/install.sh --tool chatgpt       # prints Custom GPT / Projects bundle path
```

### Web-only surfaces (no CLI required)

ChatGPT Custom GPTs, Claude Projects, and Gemini Gems can load the agents
directly. See [`integrations/chatgpt/README.md`](./integrations/chatgpt/README.md)
for setup instructions for each.

The installer only does local file copies into your tool's standard config
directory. No network calls, no sudo, no elevated privileges.

---

## Agent roster (34 agents, 7 categories)

### `cloud-cost/` -- 7 agents
Day-to-day cloud cost analysis across AWS, GCP, and Azure.

- **AWS Cost Explorer Analyst** -- CUR 2.0, Cost Categories, line-item narratives
- **GCP Billing Interpreter** -- detailed billing export, SUD/CUD, BigQuery queries
- **Azure Cost Management Navigator** -- EA / MCA, FOCUS export, management groups
- **Multi-Cloud Cost Comparator** -- unified FOCUS dataset across clouds
- **Cost Anomaly Detector** -- seasonal-aware detection that doesn't fire on Mondays
- **Forecast Model Builder** -- driver-based forecasts tied to business drivers
- **Unit Economics Modeler** -- cost per tenant, per request, per GB
- **Budget Alert Tuner** -- fewer, sharper alerts teams actually action

### `commitments/` -- 5 agents
Savings Plans, Reserved Instances, Committed Use Discounts, EDP negotiations.

- **AWS Savings Plans Strategist**
- **AWS Reserved Instance Optimizer** (RDS, ElastiCache, Redshift, DynamoDB)
- **GCP CUD Optimizer**
- **Azure Reservation Planner**
- **EDP Negotiation Coach**

### `kubernetes/` -- 3 agents
Container-level attribution and autoscaling cost tuning.

- **Kubernetes FinOps Engineer** (OpenCost / Kubecost)
- **Container Rightsizer** (CPU/memory from Prometheus percentiles)
- **Cluster Autoscaler Tuner** (Karpenter, CAS, consolidation)

### `data-platforms/` -- 3 agents
The pipelines and models behind every cost dashboard.

- **CUR & FOCUS Data Engineer** -- ingest and normalization
- **Billing Data Pipeline Architect** -- batch vs streaming, engine choice
- **Cost Warehouse Modeler** -- dimensional models, dbt, semantic layer

### `governance/` -- 6 agents
Practice operations: showback, chargeback, tagging, maturity.

- **Showback / Chargeback Architect**
- **Tag Hygiene Enforcer**
- **FinOps Governance Lead**
- **FinOps Practice Maturity Assessor**
- **Platform Team Cost Lead**
- **SRE SLO/Cost Tradeoff Analyst**

### `waste-detection/` -- 5 agents
The hunters.

- **Idle Resource Hunter**
- **Zombie NAT Gateway Detector**
- **EBS Snapshot Gardener**
- **S3 Storage Class Auditor**
- **Cross-AZ Egress Investigator**
- **Orphaned Load Balancer Hunter**

### `specialized/` -- 3 agents
Higher-leverage niches.

- **ML Workload Cost Optimizer** (training / inference)
- **Serverless Cost Profiler**
- **Spot Orchestrator**

---

## Playbooks (9 named patterns)

Named-pattern writeups for specific failure modes. Cite them by name.

**Cloud resource waste:**
- [Zombie NAT Gateway](./playbooks/zombie-nat-gateway.md)
- [Snapshot Sprawl](./playbooks/snapshot-sprawl.md)
- [Cross-AZ Chatterbox](./playbooks/cross-az-chatterbox.md)
- [Idle Load Balancer](./playbooks/idle-load-balancer.md)
- [Oversized RDS](./playbooks/oversized-rds.md)

**Reporting / allocation / governance patterns (FCP-anchored):**
- [Untagged Spend Drift](./playbooks/untagged-spend-drift.md)
- [Month-Length Illusion](./playbooks/month-length-illusion.md) -- the February "win" that isn't
- [Masked Anomaly](./playbooks/masked-anomaly.md) -- real cost blown in by a coincident commitment offset
- [Chargeback Revolt](./playbooks/chargeback-revolt.md) -- skipping showback costs 12+ months of credibility

---

## Usage examples

**Claude Code**
```
> Use the AWS Cost Explorer Analyst agent to audit last month's spend increases.
```

**Cursor**
```
Reference the Cost Anomaly Detector rule to design our alerting pipeline.
```

**Any tool**
Reference the agent by name in a conversation. The agent's persona and rules
become the working context for that task.

---

## About Cletrics

[Cletrics](https://realtimecost.com) builds real-time cloud cost
observability for teams that want to stop waiting for yesterday's data.
This repo is our open-source contribution to the FinOps community -- use it
freely, with or without Cletrics the product.

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md). Pull requests welcome for new
agents, new playbooks, tooling improvements, and localizations.

Please respect the 90/10 rule: agents and playbooks are generic FinOps
resources. Product references stay minimal.

## License

MIT. See [LICENSE](./LICENSE). Trademark and attribution terms in
[NOTICE](./NOTICE).

"Cletrics" is a trademark of Cletrics. Fork freely; don't imply endorsement.

## Security

See [SECURITY.md](./SECURITY.md) for the disclosure policy.
