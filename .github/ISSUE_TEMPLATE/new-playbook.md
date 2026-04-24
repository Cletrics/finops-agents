---
name: Propose a new playbook
about: Document a named FinOps failure pattern
title: "[PLAYBOOK] <pattern name>"
labels: playbook-proposal
---

## Pattern name

<short, memorable name — e.g., "Zombie NAT Gateway", "Snapshot Sprawl">

## Scope

- [ ] aws
- [ ] gcp
- [ ] azure
- [ ] all-clouds
- [ ] kubernetes
- [ ] other (specify)

## Problem

One paragraph. What is the failure mode? Why is it common?

## Detection

How would a practitioner measure this? (CUR query, CloudWatch metric,
BigQuery query, kubectl output, etc.)

## Fix

Numbered steps. Non-vendor-specific where possible.

## Anti-patterns

What not to do. Common mistakes in the remediation itself.
