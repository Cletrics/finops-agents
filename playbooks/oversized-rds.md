---
name: Oversized RDS
description: RDS instance sized for an imagined peak that never arrives. High CPU and memory headroom, low actual usage, full commitment pricing.
scope: aws
color: "#DC2626"
emoji: 🗃️
---

## Problem

Teams size RDS instances conservatively for peak + 3x buffer, then never
revisit. An `r6g.4xlarge` running at 8% CPU average costs ~$700/month;
downsizing to `r6g.xlarge` at 32% CPU average saves ~$525/month with no
user-visible impact.

## Symptoms

- CloudWatch `CPUUtilization` 30-day average < 20%
- `FreeableMemory` consistently > 50% of instance memory
- `DatabaseConnections` well below `max_connections` limit
- Pre-Gravityon instance class still running (paying ARM premium by not using ARM)

## Detection

```sql
-- CloudWatch metrics in Athena via Metric Streams
SELECT
  resource_id,
  AVG(cpu_utilization_avg) AS avg_cpu_pct,
  AVG(freeable_memory_bytes) / AVG(instance_memory_bytes) AS free_mem_pct,
  MAX(db_connections_max) AS peak_connections
FROM rds_metrics_last_30d
WHERE resource_type = 'rds-instance'
GROUP BY resource_id
HAVING AVG(cpu_utilization_avg) < 20
   AND AVG(freeable_memory_bytes) / AVG(instance_memory_bytes) > 0.5
ORDER BY avg_cpu_pct;
```

## Fix

1. Verify 30-day metrics include peak periods (month-end batch, marketing events)
2. Propose downsize: one instance class smaller, same family
3. Consider migration to Graviton (r6g, r7g, r8g) for ~20% discount
4. Schedule maintenance window for the downsize
5. Monitor 72 hours post-change; be prepared to roll back
6. If multi-AZ, ensure failover tested first

## Anti-pattern

- **Downsizing aggressively based on 7-day window**: Miss the monthly or quarterly peak.
- **Downsizing an RI'd instance without exchange**: Reserved instance scope pins you; exchange first.
- **Downsizing storage at the same time**: Compound rollback risk.

## References

- [RDS instance types](https://aws.amazon.com/rds/instance-types/)
- [AWS Graviton for RDS](https://aws.amazon.com/rds/aurora/graviton/)
- Agent: `commitments/aws-reserved-instance-optimizer.md`
