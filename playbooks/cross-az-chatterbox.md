---
name: Cross-AZ Chatterbox
description: A service pair that emits high volumes of cross-AZ traffic and burns data transfer charges.
scope: all-clouds
color: "#DC2626"
emoji: 🌉
---

## Problem

Two services co-located in the same region but different AZs emit
high-volume east-west traffic. AWS bills $0.01/GB in each direction for
cross-AZ traffic ($0.02/GB round-trip). Microservices with high chattiness
and no topology awareness generate thousands of dollars per month in
cross-AZ alone.

## Symptoms

- Data Transfer line items account for > 5% of total cloud spend
- Kubernetes services without topology-aware routing hints
- Kafka / Kinesis / ElastiCache replication costs dwarf the compute that runs them
- Load balancer hairpin traffic (ALB/NLB sending traffic back across AZs)

## Detection

```sql
-- VPC Flow Logs via Athena: top cross-AZ source-destination pairs
SELECT
  srcaddr, dstaddr,
  src_az, dst_az,
  SUM(bytes) / 1024 / 1024 / 1024 AS gb
FROM vpc_flow_logs
WHERE date >= current_date - interval '7' day
  AND src_az != dst_az
  AND src_az IS NOT NULL
  AND dst_az IS NOT NULL
GROUP BY 1, 2, 3, 4
ORDER BY gb DESC
LIMIT 20;
```

## Fix

1. Enable topology-aware routing:
   - Kubernetes: `topologySpreadConstraints` + topology-aware hints
   - AWS Service Connect / App Mesh: same-AZ preference
   - HAProxy / NGINX: health-check-aware upstream selection
2. Replace synchronous chat with async where possible (SQS / SNS / EventBridge)
3. Introduce caching at the service boundary
4. Pool connections -- kill per-request connection overhead
5. For replication-heavy systems: evaluate single-AZ-with-MAZ-snapshot vs multi-AZ

## Anti-pattern

- **Collapsing to single AZ to save cross-AZ**: Breaks the primary reliability design. Cheaper, less reliable.
- **Using VPC peering to "fix" cross-AZ**: Peering doesn't remove cross-AZ charges.
- **Optimizing without measuring**: Fix what you can attribute. Blanket "reduce microservice chat" is not a fix.

## References

- [AWS Data Transfer pricing](https://aws.amazon.com/ec2/pricing/on-demand/#Data_Transfer)
- [Kubernetes topology-aware hints](https://kubernetes.io/docs/concepts/services-networking/topology-aware-routing/)
- Agent: `waste-detection/cross-az-egress-investigator.md`
