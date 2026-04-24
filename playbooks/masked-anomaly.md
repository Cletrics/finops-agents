---
name: Masked Anomaly
description: A real cost anomaly (unplanned workload, misconfigured resource, accidental region) is hidden from high-level reporting because a concurrent commitment purchase or RI application offsets the delta. Legitimately big spend sneaks in looking like normal.
scope: all-clouds
color: "#DC2626"
emoji: 🎭
fcp_domain: "Understand Usage & Cost"
fcp_capability: "Anomaly Management"
fcp_phases: ["Inform","Operate"]
fcp_anchor: "FCP Lesson 10 -- Inform Phase (pharma case study)"
---

## Problem

Threshold-based anomaly detection breaks when two changes of opposite sign
happen in the same billing period. The canonical FCP pharma story: a
remote engineering team spins up three `x1e.32xlarge` instances in Sydney
(>$44/hr each, ~$98K/month) for in-memory database testing. In the same
billing period, the central FinOps team buys RIs that reduce on-demand
spend on another workload by roughly the same amount. Net delta ≈ 2% on a
$3.5M/month bill. High-level dashboards show "normal," and the anomaly is
invisible for weeks.

Masked anomalies are worse than unmasked ones: you don't know to look, you
lose any ability to detect them via monthly totals, and you have no
conversation about whether the new spend was intentional or authorized.

## Symptoms

- Monthly totals flat or slightly declining, yet investigation (when
  triggered by something else) surfaces both meaningful new spend and
  meaningful new savings in the same period
- Anomaly tooling configured only on total spend, not on subsets
- Savings Plan / RI purchases coincidentally timed with workload launches
  on unrelated teams
- After-the-fact audits find "we've been running that since March" for
  resources that were never sanctioned

## Detection

Layered detection is the only reliable answer. Configure anomaly rules at
multiple scopes simultaneously:

```sql
-- Per-service, per-region, per-account, per-tag anomaly scoring.
-- Compute deltas in multiple dimensions and alert on any outlier,
-- not just the aggregate.
WITH baseline AS (
  SELECT
    service,
    region,
    account_id,
    tag_team,
    AVG(daily_cost) AS mean_cost,
    STDDEV(daily_cost) AS std_cost
  FROM focus_daily_cost
  WHERE usage_date BETWEEN current_date - interval '60' day
                       AND current_date - interval '31' day
  GROUP BY 1,2,3,4
),
recent AS (
  SELECT service, region, account_id, tag_team,
         AVG(daily_cost) AS recent_cost
  FROM focus_daily_cost
  WHERE usage_date >= current_date - interval '30' day
  GROUP BY 1,2,3,4
)
SELECT r.*, b.mean_cost, b.std_cost,
       (r.recent_cost - b.mean_cost) / NULLIF(b.std_cost, 0) AS z_score
FROM recent r
JOIN baseline b USING (service, region, account_id, tag_team)
WHERE ABS((r.recent_cost - b.mean_cost) / NULLIF(b.std_cost, 0)) > 3
  AND r.recent_cost > 5000  -- ignore noise
ORDER BY ABS(z_score) DESC;
```

## Fix

1. **Layer anomaly detection** across service, region, account, tag,
   workload. Aggregate alerts are necessary but insufficient.
2. **Use ML-based detection** for major cloud scopes. AWS Cost Anomaly
   Detection, Azure anomaly detection in Cost Management, GCP budget
   anomaly alerts -- configure all of them, not one.
3. **Separate "commitment discount applied" as its own axis.** A drop
   attributable to a commitment purchase should not cancel out an
   unrelated rise in a different workload. Report both as discrete
   events.
4. **Alert on NEW services or NEW regions** in any account, at any cost
   above a small threshold. New usage in Sydney at $98K/month is a
   different signal from existing usage growing 5%.
5. **Share anomaly details with Security.** Sudden large spend in an
   unexpected region is also a potential security incident
   (cryptomining, exfiltration, compromised credentials).

## Anti-pattern

- **Single threshold on total spend**: The pharma case shows exactly how
  this fails.
- **Monthly anomaly review only**: Masked anomalies can run for the full
  month before they're noticed.
- **"It balanced out"**: Two unrelated changes netting to zero is not
  stability, it's hidden risk.

## References

- Agent: `cloud-cost/cost-anomaly-detector.md`
- FinOps Framework: [Anomaly Management Capability](https://www.finops.org/framework/capabilities/anomaly-management/)
- FCP course anchor: Lesson 10 "Inform Phase" -- pharma case study
