# Repo metadata (for `gh repo create` / `gh repo edit`)

One-line description (< 140 chars):

> 34 FinOps specialist AI agents + 6 named-pattern playbooks. Drop into Claude Code, Copilot, Cursor, Windsurf, Aider, Gemini CLI. MIT.

Topics (GitHub repo topics, lowercase, max 20):

```
finops
cloud-cost
aws
gcp
azure
kubernetes
focus-spec
cur
billing
cost-optimization
claude-code
cursor
copilot
windsurf
aider
agents
ai-agents
prompt-engineering
devops
sre
```

Social preview image:
- 1280x640 PNG. Black background. "Cletrics FinOps Agents" in large
  sans-serif. Subtitle: "34 specialists. 6 playbooks. Zero lock-in."
  MIT badge in corner. Upload via Settings -> General -> Social preview.

Website field:
- https://realtimecost.com

Home repo pin:
- Pin to RunAIPilot profile (or cletrics org once created).

`gh` commands (run after org/repo created):

```bash
gh repo edit cletrics/finops-agents \
  --description "34 FinOps specialist AI agents + 6 named-pattern playbooks. Drop into Claude Code, Copilot, Cursor, Windsurf, Aider, Gemini CLI. MIT." \
  --homepage "https://realtimecost.com" \
  --add-topic finops,cloud-cost,aws,gcp,azure,kubernetes,focus-spec,cur,billing,cost-optimization,claude-code,cursor,copilot,windsurf,aider,agents,ai-agents,prompt-engineering,devops,sre \
  --enable-issues \
  --enable-discussions
```
