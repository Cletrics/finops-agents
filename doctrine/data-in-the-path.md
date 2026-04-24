# Doctrine: Data in the Path

> "FinOps is successful when every Persona is doing FinOps as part of
> their regular job, not when only a FinOps team is doing FinOps."
> -- FCP Lesson 9

A report that lives in a FinOps dashboard nobody opens is worth zero.
The data has to appear where the Persona is already working -- their
Slack channel, their Jira backlog, their Grafana, their GitHub PR
checks, their Finance quarterly-close workbook.

J.R. Storment's canonical example: a company running ~9 figures/year in
cloud, where nobody shared costs with engineers. When the data finally
made it in front of an engineering manager, one team found $200K/month
of unnecessary dev environments and shut them down in 3 hours. The data
had existed the whole time. It just wasn't in the path.

## How agents should use this

Every agent that produces a report, dashboard, recommendation, or metric
should close its Technical Deliverables section with an explicit
"Integration points" statement. Format:

> **Integration points.** This output lands in:
> - [Persona 1's existing tool] via [mechanism]
> - [Persona 2's existing tool] via [mechanism]
> Do not ship a standalone FinOps-only dashboard; route into workflows
> that already have attention.

## Standard integration mechanisms by Persona

| Persona | Where they already look | How the data arrives |
|---|---|---|
| Engineering | Slack, GitHub PR checks, Grafana, Jira | Bot posts, PR cost-delta comments, dashboard panels, Jira tickets with cost context |
| Product | Product analytics tool, sprint review decks | Unit-economics KPI in the product dashboard; cost-per-feature in sprint review |
| Finance | Excel / Google Sheets, ERP, quarterly close workbook | FOCUS-conformed CSV export; monthly journal entries via chargeback pipeline |
| Leadership | Exec dashboard, monthly business review | One-page trend + top movers; unit cost per business metric |
| Procurement | Contract lifecycle management, supplier scorecards | Commitment coverage/utilization; marketplace spend attribution |
| Security | SIEM, alert console | Anomaly feed for unexpected spend in unexpected regions |
| Sustainability | ESG reporting platform | Carbon-per-workload + region-carbon map |

## Anti-patterns

- **"I'll build a FinOps dashboard and invite people to it."** Builds
  a dashboard nobody logs into. Integrate into their existing surfaces.
- **Email digests as primary delivery.** Low-attention channel. OK as
  a nudge; not OK as the only path.
- **Dashboards without action paths.** A chart that shows a problem
  without a one-click path to action generates awareness, not behavior
  change. Add the "who owns this + how to escalate" metadata.

## Related

- FCP Lesson 9 -- the Prius Effect, continuous feedback
- [Iron Triangle doctrine](./iron-triangle.md)
- Agent: `governance/finops-enablement-lead.md`
