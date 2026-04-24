---
name: Idle Load Balancer
description: An ALB, NLB, or Classic LB with no healthy targets or no traffic -- pure waste at ~$16+/month base.
scope: aws
color: "#DC2626"
emoji: 🚧
---

## Problem

An AWS ALB costs ~$16.20/month in base hourly charges before any LCU
(Load Balancer Capacity Units). An idle ALB with no healthy targets,
or an LB routing zero meaningful traffic, is pure waste. At scale
(multi-account orgs), dozens of orphaned LBs are common.

## Symptoms

- `HealthyHostCount` == 0 sustained over 30 days
- `RequestCount` == 0 sustained over 30 days
- Target group with all targets de-registered
- Listener pointing to a target group with no targets

## Detection

```python
# Boto3 snippet: LBs with zero healthy hosts for 30 days
import boto3
from datetime import datetime, timedelta

elbv2 = boto3.client('elbv2')
cw = boto3.client('cloudwatch')

lbs = elbv2.describe_load_balancers()['LoadBalancers']
idle = []
for lb in lbs:
    arn_suffix = '/'.join(lb['LoadBalancerArn'].split(':')[-1].split('/')[1:])
    stats = cw.get_metric_statistics(
        Namespace='AWS/ApplicationELB',
        MetricName='HealthyHostCount',
        Dimensions=[{'Name': 'LoadBalancer', 'Value': arn_suffix}],
        StartTime=datetime.utcnow() - timedelta(days=30),
        EndTime=datetime.utcnow(),
        Period=86400,
        Statistics=['Maximum'],
    )
    if stats['Datapoints'] and max(p['Maximum'] for p in stats['Datapoints']) == 0:
        idle.append(lb['LoadBalancerName'])

print(idle)
```

## Fix

1. Confirm no DNS records reference the LB (Route 53, external DNS, hardcoded endpoints)
2. Notify the owning team (identify via tags; if untagged, escalate)
3. Tag LB with `decommission-pending: <date>`
4. Wait 30 days (retention)
5. Delete listeners first (faster rollback)
6. Delete target groups
7. Delete LB

## Anti-pattern

- **Deleting without DNS check**: Breaks traffic that was silently routing through DNS.
- **Treating DR-standby LBs as idle**: Tag these explicitly to avoid false positives.
- **Cleanup without owner notification**: Owner surprises = lost political capital.

## References

- [ALB pricing](https://aws.amazon.com/elasticloadbalancing/pricing/)
- Agent: `waste-detection/orphaned-load-balancer-hunter.md`
