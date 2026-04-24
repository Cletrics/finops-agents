---
name: Snapshot Sprawl
description: Gradual accumulation of EBS (or equivalent) snapshots -- individually cheap, collectively expensive.
scope: all-clouds
color: "#DC2626"
emoji: 🌿
---

## Problem

Snapshots accumulate from many sources: automated backup policies without
lifecycle, manual "just in case" snapshots, deregistered AMI chains,
forgotten DR copies. Each is a few cents per GB-month. At fleet scale,
they become five- to six-figure annual costs with no corresponding
business value.

## Symptoms

- Snapshot count growing month-over-month with no corresponding volume growth
- "Snapshots" line item in the CUR > 5% of total EBS spend
- Snapshots older than 2 years with no obvious lineage
- Orphaned snapshots (parent volume deleted)
- Cross-region snapshot copies for regions you no longer operate in

## Detection

```sql
-- CUR query: snapshot storage cost by account, trend last 6 months
SELECT
  line_item_usage_account_id AS account,
  date_trunc('month', line_item_usage_start_date) AS month,
  SUM(line_item_usage_amount) AS gb_months,
  SUM(line_item_unblended_cost) AS cost
FROM cur2
WHERE line_item_usage_start_date >= current_date - interval '180' day
  AND product_servicecode = 'AmazonEC2'
  AND line_item_usage_type LIKE '%EBS:SnapshotUsage%'
GROUP BY 1, 2
ORDER BY account, month;
```

```bash
# Orphaned snapshot count (AWS CLI)
aws ec2 describe-snapshots --owner-ids self --query 'length(Snapshots[?starts_with(Description, `Created by CreateImage`) == `false`])'
```

## Fix

1. Enable AWS Data Lifecycle Manager (DLM) or equivalents for new snapshots
2. Inventory current snapshots; classify as:
   - Orphaned (parent volume deleted) -- candidates for deletion after holdback
   - AMI-backing -- cannot delete without deregistering AMI
   - Legal hold / compliance -- must retain per policy
   - Aged but active-parent -- review per data-retention policy
3. For orphaned: apply 90-day holdback tag, then delete
4. For AMI-backing obsolete AMIs: deregister + delete
5. Publish the lifecycle policy; audit quarterly

## Anti-pattern

- **Blanket "delete snapshots > 1 year old"**: Compliance violations waiting to happen.
- **No holdback period**: Accidental deletions of recovery-critical snapshots.
- **Manual cleanup without lifecycle policy**: Sprawl resumes the moment the cleanup stops.

## References

- [AWS Data Lifecycle Manager](https://docs.aws.amazon.com/ebs/latest/userguide/snapshot-lifecycle.html)
- [GCP snapshot schedules](https://cloud.google.com/compute/docs/disks/scheduled-snapshots)
- [Azure snapshot retention](https://learn.microsoft.com/en-us/azure/virtual-machines/snapshot-copy-managed-disk)
- Agent: `waste-detection/ebs-snapshot-gardener.md`
