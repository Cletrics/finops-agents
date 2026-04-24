---
name: Zombie NAT Gateway
description: A NAT Gateway that processes minimal traffic but accrues hourly charges -- a high-$/hour waste pattern.
scope: aws
color: "#DC2626"
emoji: 🧟
---

## Problem

A NAT Gateway is billed hourly ($0.045/hr in most regions = ~$32/month) plus
per-GB data processing ($0.045/GB in most regions). A gateway processing
very little data still accrues the full hourly charge. Multiply across
accounts and AZs and the waste compounds quickly.

## Symptoms

- `BytesOutToSource` + `BytesOutToDestination` CloudWatch metrics are < 5 GB/month
- Private subnet has few or no running workloads
- NAT was created during a migration that ended months ago
- Account has multiple NAT Gateways but one or two AZs see no egress

## Detection

```sql
-- Athena query over CUR 2.0 -- NAT Gateway hours vs data processed
SELECT
  line_item_resource_id AS nat_id,
  line_item_availability_zone AS az,
  SUM(CASE WHEN line_item_usage_type LIKE '%NatGateway-Hours' THEN line_item_usage_amount END) AS hours,
  SUM(CASE WHEN line_item_usage_type LIKE '%NatGateway-Bytes' THEN line_item_usage_amount END) / 1024 / 1024 / 1024 AS gb_processed,
  SUM(line_item_unblended_cost) AS cost_month
FROM cur2
WHERE line_item_usage_start_date >= date_trunc('month', current_date - interval '1' month)
  AND line_item_usage_start_date <  date_trunc('month', current_date)
  AND product_servicecode = 'AmazonEC2'
  AND line_item_usage_type LIKE '%NatGateway%'
GROUP BY 1, 2
HAVING SUM(CASE WHEN line_item_usage_type LIKE '%NatGateway-Bytes' THEN line_item_usage_amount END) / 1024 / 1024 / 1024 < 5
ORDER BY cost_month DESC;
```

## Fix

1. Check route tables -- confirm no active subnets rely on the NAT
2. Check CloudWatch metrics for the last 30 days
3. Consider replacement:
   - Heavy S3 / DynamoDB traffic → VPC Gateway Endpoint (free)
   - Heavy SaaS traffic → VPC Interface Endpoint (cheaper at scale)
   - Low traffic → delete the NAT entirely
4. For multi-AZ redundancy requirements with low traffic, consider centralized NAT via Transit Gateway
5. Delete the NAT; update route tables

## Anti-pattern

- **"We might need it later"**: The hourly charge accumulates regardless. Recreate when actually needed; it takes minutes.
- **Deleting without route-table check**: Breaks production if any subnet still routes through it.
- **Replacing with Interface Endpoints blindly**: Interface endpoints cost hourly too. Run the math.

## References

- [AWS NAT Gateway pricing](https://aws.amazon.com/vpc/pricing/)
- [VPC Gateway Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html)
- Agent: `waste-detection/zombie-nat-gateway-detector.md`
