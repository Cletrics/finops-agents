# Contributing to Cletrics FinOps Agents

Thanks for helping build the open-source reference library for cloud cost
operations. This repo is a community resource: agent personas, playbooks,
and integration plumbing that work in any modern coding assistant.

## Ground rules

1. **Value first.** Every agent or playbook must stand on its own merit as
   generic FinOps guidance. If the content doesn't help a reader who has never
   heard of Cletrics, it doesn't belong here.
2. **90/10 brand rule.** At most ONE subtle reference to Cletrics or
   realtimecost.com per agent, and only when the reference is genuinely useful
   (e.g., "tools like Cletrics can subscribe to these streams"). The lint
   script enforces this.
3. **No destructive instructions.** Agents must never tell a downstream coding
   agent to run destructive commands, exfiltrate data, or bypass user safeguards.
4. **No secrets.** No API keys, tokens, customer cost data, tenant IDs, or
   account numbers in any committed file.
5. **Vendor-neutral voice.** Reference AWS, GCP, Azure, OCI, Alibaba Cloud by
   their canonical names. Avoid taking sides unless the guidance itself is
   vendor-specific.

## How to add a new agent

1. Pick the right category directory:
   - `cloud-cost/` -- cost explorer, forecasting, anomaly detection, unit economics
   - `commitments/` -- Savings Plans, RIs, CUDs, reservations, EDP negotiation
   - `kubernetes/` -- container/cluster cost
   - `data-platforms/` -- CUR, FOCUS, pipelines, warehousing cost data
   - `governance/` -- showback, chargeback, tagging, policy, maturity
   - `waste-detection/` -- idle/zombie/orphaned resource hunters
   - `specialized/` -- ML/GPU, serverless, spot, anything that doesn't fit above
2. Copy the nearest neighbor agent as a template.
3. Fill in frontmatter: `name`, `description`, `color`, optional `emoji`, `vibe`, `tools`.
4. Write: Identity, Core Mission, Critical Rules, Technical Deliverables,
   Workflow, Communication Style. Keep the body tight -- 80 to 150 lines.
5. Run `./scripts/lint-agents.sh <your-file>` -- must pass.
6. Open a PR with the template in `.github/PULL_REQUEST_TEMPLATE.md`.

## How to add a new playbook

Playbooks are named-pattern writeups for specific cloud cost failure modes.
Format: problem, symptoms, detection query, fix, anti-pattern, references.

1. Add a file in `playbooks/` named after the pattern (e.g., `zombie-nat-gateway.md`).
2. Use `playbooks/zombie-nat-gateway.md` as the canonical template.
3. Keep examples vendor-neutral where possible. If vendor-specific (e.g., AWS
   NAT Gateway pricing), say so in the frontmatter `scope` field.

## Shell script changes

- `install.sh`, `convert.sh`, `lint-agents.sh` must remain network-free and
  never require sudo.
- New install targets (tools) go in `scripts/install.sh` following the pattern
  of existing `install_<tool>()` functions.
- Add a matching `convert_<tool>()` in `scripts/convert.sh` if the tool needs
  a format different from the source `.md`.

## Style

- Markdown. No HTML. No emojis in frontmatter except in dedicated `emoji:` field.
- Short sentences. Bulleted deliverables. Fewer words beats more.
- Cite authoritative sources (FinOps Foundation, AWS/GCP/Azure official pricing docs).
