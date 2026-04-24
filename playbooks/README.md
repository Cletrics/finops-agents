# Cloud Cost Playbooks

Named patterns for specific cloud cost failure modes. Each playbook follows
the same shape, inspired by Martin Fowler's refactoring catalog: a problem,
the symptoms that reveal it, a detection query, the fix, and an anti-pattern
to avoid.

These are meant to be cited by name: "This looks like a Zombie NAT Gateway"
becomes a common shorthand across the team.

## Playbook template

```
---
name: <Pattern Name>
description: <One-line summary>
scope: <all clouds | aws | gcp | azure>
color: ...
---

## Problem
## Symptoms
## Detection
## Fix
## Anti-pattern
## References
```

## Current catalog

- [zombie-nat-gateway](./zombie-nat-gateway.md)
- [snapshot-sprawl](./snapshot-sprawl.md)
- [cross-az-chatterbox](./cross-az-chatterbox.md)
- [idle-load-balancer](./idle-load-balancer.md)
- [oversized-rds](./oversized-rds.md)
- [untagged-spend-drift](./untagged-spend-drift.md)
