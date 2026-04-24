---
name: Untagged Spend Drift
description: Percentage of cloud spend without required tags grows over time, hollowing out every chargeback and showback report.
scope: all-clouds
color: "#DC2626"
emoji: 🏷️
---

## Problem

An organization establishes a tag taxonomy, reports 95% coverage, then
never measures again. Over 6-12 months, coverage drifts down as new
resources are created without enforcement, legacy resources are
recreated, and workloads migrate. By the time anyone notices, untagged
spend is 20-30% of total -- and every team-level cost conversation is
caveated into uselessness.

## Symptoms

- Monthly coverage report not produced, or produced but not reviewed
- "Untagged" or "Unknown team" line item growing in the CUR
- Showback reports increasingly caveated with "excludes 18% unallocated"
- New accounts / subscriptions created without baseline tag policies

## Detection

```sql
-- CUR query: tag coverage for mandatory "team" tag, last 30 days
WITH daily_tagged AS (
  SELECT
    date_trunc('day', line_item_usage_start_date) AS day,
    CASE WHEN resource_tags_user_team != '' AND resource_tags_user_team IS NOT NULL
         THEN 'tagged' ELSE 'untagged' END AS status,
    SUM(line_item_unblended_cost) AS cost
  FROM cur2
  WHERE line_item_usage_start_date >= current_date - interval '30' day
  GROUP BY 1, 2
)
SELECT
  day,
  SUM(CASE WHEN status = 'tagged' THEN cost END) / SUM(cost) AS coverage_pct,
  SUM(CASE WHEN status = 'untagged' THEN cost END) AS untagged_cost
FROM daily_tagged
GROUP BY day
ORDER BY day;
```

## Fix

1. Re-publish the tag taxonomy (one page, canonical)
2. Deploy policy-as-code to enforce mandatory tags at resource creation:
   - AWS: Organizations Tag Policies + SCP requiring mandatory tags
   - Azure: Azure Policy with `deny` effect on missing tags
   - GCP: Organization Policies + label-conventions enforcement via Terraform
3. Inventory legacy untagged resources; assign owners via CloudTrail creation events
4. Run a time-boxed remediation campaign (60-90 days)
5. Publish coverage weekly; set an SLO (e.g., "> 95% coverage").
6. Review monthly at the FinOps cadence

## Anti-pattern

- **One-time audit, no ongoing measurement**: Drift returns in < 6 months.
- **"Warning" policies instead of "deny"**: Warnings get ignored; denies work.
- **Blanket default tags**: Creates false coverage -- every resource has a tag but it's `team: unknown`, which is functionally identical to untagged.

## References

- [AWS Tag Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_tag-policies.html)
- [Azure Policy tag enforcement](https://learn.microsoft.com/en-us/azure/governance/policy/tutorials/govern-tags)
- Agent: `governance/tag-hygiene-enforcer.md`
