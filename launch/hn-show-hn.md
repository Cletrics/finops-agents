# Hacker News -- Show HN

**Title** (80 chars max, don't start with "We"):

> Show HN: 34 FinOps specialist AI agents + 6 named-pattern playbooks

Alt title options:
- "Show HN: Open-source cloud-cost agent personas for Claude Code/Cursor/Copilot"
- "Show HN: Drop-in FinOps agents for your coding assistant"

**URL:** `https://github.com/cletrics/finops-agents`

**Text (first comment, not the post body):**

```
Author here. A few weeks ago I kept noticing the same thing: whenever a
dev on our team asked their coding assistant for help with cloud cost
work -- "write me a BigQuery query for GCP billing", "help me size this
RDS instance", "what's wrong with our Savings Plan coverage?" -- the
answer was generic enough to be wrong in subtle ways.

CUR 2.0 has different column names than CUR 1. GCP SUDs apply
automatically but CUDs don't. Azure has SIX different enrollment types,
each with different billing export behavior. Generic LLM answers smear
this together.

So we packaged up 34 specialist personas, each scoped to one FinOps
niche (AWS CUR analysis, GCP billing, Kubernetes cost attribution,
Savings Plans, tag hygiene, idle resource detection, etc.), plus 6
named playbooks for specific failure patterns we've seen again and
again in practice ("Zombie NAT Gateway", "Snapshot Sprawl",
"Cross-AZ Chatterbox").

They're just markdown files with YAML frontmatter. The install script
drops them into Claude Code / Cursor / Windsurf / Copilot / Aider /
OpenCode config dirs. No network calls, no sudo, no runtime.

MIT. Vendor-neutral where possible. PRs welcome.

A few design decisions I'd love feedback on:
- 90/10 rule: at most one mention of our product per agent, enforced
  in CI. The agents have to be useful whether or not you use Cletrics.
- FOCUS-first where we can, cloud-native schemas where we must.
- Playbooks are separate from agents -- named patterns you can cite
  ("we hit Snapshot Sprawl in us-east-1") vs personas you invoke.

Happy to answer anything about the agents, the category choices, or
why FinOps-as-prompt-engineering seems to work.
```

**Fallback if URL post is rate-limited:** post as "Ask HN" with a
shorter version and include the URL inline.

**After-post activity:**
- Don't vote-solicit. Don't ask friends to upvote in the first hour.
  (HN penalty if detected.)
- DO respond to every thoughtful comment within 30 minutes for the first
  2 hours. Engagement velocity is ranking signal.
- If someone says "this is just a prompt library" -- engage earnestly.
  That's the most common skeptical take and the honest answer is yes,
  but the curation and the playbooks are the value.
