---
name: FOCUS Adoption -- Parallel Run
description: Migrating to FOCUS-formatted billing data without losing reconciliation, audit trails, or stakeholder trust. Run FOCUS and legacy reporting in parallel until reconciled, then cut over.
scope: all-clouds
color: "#0EA5E9"
emoji: 🪞
fcp_domain: "Understand Usage & Cost"
fcp_capability: "Data Ingestion"
fcp_phases: ["Inform","Operate"]
fcp_anchor: "FOCUS Analyst course Lesson 3 -- STMicroelectronics, GitLab, Zoom, UnitedHealth Group, European Parliament case studies"
---

## Problem

Switching cost reporting from a vendor-native billing schema (CUR, GCP
billing export, Azure Cost Management) to FOCUS is not a flip. The
business runs on the old reports. Finance reconciles to the old
columns. Allocation rules, dashboards, anomaly detectors, and chargeback
flows all reference the old shape. A hard cut-over breaks all of them
simultaneously, with no way to confirm the new numbers are right.

What practitioners learn the hard way: **FOCUS migration is a financial
systems migration**, not a schema swap. Every financial systems
migration that has ever worked used a parallel-run period to reconcile
old to new before turning the old one off.

## Symptoms

- "We tried FOCUS but the numbers don't match the invoice."
- Finance refuses to accept FOCUS-derived chargeback because they can't
  trace it back to the legacy cost column.
- Allocation reports break when teams cut over -- different aggregation
  rules expose tag gaps or hierarchy mismatches.
- Anomaly detectors need rebuilding because thresholds were tuned on
  Billed Cost shapes that don't match Effective Cost behavior.
- Stakeholders mistrust the new dataset because the cut-over surprised
  them.

## Fix: parallel run, reconcile, cut over

Treat the migration like an ERP migration. Five-stage flow:

### Stage 1 -- Stand up FOCUS in parallel

- Turn on FOCUS exports for every available data generator
  (<https://focus.finops.org/get-started/>).
- Land the FOCUS dataset in the same warehouse as the legacy export,
  side by side.
- Do **not** retire the legacy ingestion. Both run, both feed the
  warehouse, neither is canonical yet.
- Separate **ingestion** from **enrichment** and **allocation** so
  reruns after forecast or allocation changes don't require
  re-extracting data (STMicroelectronics pattern).

### Stage 2 -- Reconcile

For each billing period under parallel run:

| Compare this | Against this | Tolerance |
|---|---|---|
| Sum of FOCUS `BilledCost` for billing account | Sum of legacy "billed/unblended" for same account | < 0.5% |
| Sum of FOCUS `EffectiveCost` per billing period | Legacy amortized view | Will diverge by amortization periods -- explain, don't equalize |
| FOCUS `InvoiceId` totals | Provider invoice PDF totals | Exact match per invoice |
| FOCUS `ServiceCategory` group totals | Legacy service-grouped totals | Some redistribution expected (different category definitions) |

Document every discrepancy. Some divergence is **expected** because
FOCUS normalizes definitions that providers used loosely. The job is to
explain divergence, not erase it.

Use the FOCUS Validator
(<https://github.com/finopsfoundation/focus_validator>) and Requirements
Analyzer
(<https://finops-open-cost-and-usage-spec.github.io/focus_requirements_model_analyzer/>)
during this stage. Flag conditional-requirement false positives but
don't suppress them blindly.

### Stage 3 -- Migrate consumers, one at a time

Don't try to switch every report at once. Sequence:

1. **Reporting & Analytics** dashboards -- highest visibility, easiest
   reversibility. Build FOCUS versions of the top 5-10 reports;
   confirm with stakeholders side-by-side.
2. **Anomaly detection** -- retune thresholds against FOCUS
   `EffectiveCost` distributions; keep legacy detector live as
   shadow until tuning is settled.
3. **Allocation / chargeback** -- this is where reorganizations bite.
   See "External allocation keys" below.
4. **Forecasting** -- driver-based forecasts adapt naturally; pure
   statistical forecasts need re-baselining.
5. **Procurement / commitment** -- commitment optimizers need
   `CommitmentDiscountStatus` (Used / Unused) wired before they trust
   FOCUS data.

For each consumer, run FOCUS-derived output and legacy output in
parallel for at least one full billing cycle. Don't promote until
stakeholders accept.

### Stage 4 -- External allocation keys

If the organization reorganizes (M&A, restructure, team boundary
changes), tag-based allocation breaks. STM's pattern: manage allocation
keys **outside** the cloud provider. Use stable provider metadata
(Subscription / Resource Group, Account / Folder, Account / OU) as the
anchor; map to an external allocation system that absorbs the
reorganization without touching cloud tags.

This pattern is most valuable at Walk maturity in Allocation. At Crawl
it's overkill; at Run it's table stakes.

### Stage 5 -- Cut over

When every consumer has accepted parallel output for a full cycle:
1. Mark FOCUS as canonical in the catalog.
2. Stop new development against legacy schemas.
3. Keep legacy ingestion running in **read-only archival mode** for at
   least 12 months for audit lookback.
4. Communicate the cut-over date in advance; publish a migration FAQ.

## Anti-patterns

- **Hard cut-over without parallel run.** "We're switching everyone to
  FOCUS Monday." Stakeholders revolt; trust collapses; you fall back
  and lose 6 months of progress.
- **Reconciling to perfect equality.** Some divergence between FOCUS
  and legacy is the *point* -- FOCUS clarifies definitions that
  providers used inconsistently. Explain the gap, don't paper over it.
- **Migrating allocation before reporting.** Allocation downstream of
  unstable reporting compounds errors. Migrate visibility first.
- **Skipping the Validator.** Conformance issues caught early are
  cheap; conformance issues caught after stakeholders depend on the
  data are expensive.
- **Letting the legacy pipeline rot during parallel run.** If the
  legacy pipeline silently breaks halfway through reconciliation, you
  lose the comparison baseline. Treat it as load-bearing until cut-over
  completes.
- **Tag-only allocation in a reorganizing company** (STM warning).
  Tags drift faster than cloud metadata; external keys are more
  durable.

## Variants by case study

| Case | Twist |
|---|---|
| **STMicroelectronics** | Centralized commitment purchasing; small well-connected FinOps team; 3-month pay-as-you-go for new workloads before committing |
| **GitLab** | Custom pipeline (FOCUS converter → Snowflake → DBT → Tableau); allocation built from Prometheus/Thanos/product telemetry; unit economics at GA |
| **Zoom** | Treat as formal initiative tracked in Jira with quarterly OKRs (~95% allocation, 75% utilization, 85% chargeback accuracy, >90% anomaly visibility) |
| **UnitedHealth Group** | Hybrid (data center + cloud); "double bubble" overlap cost; network cost models differ radically -- pipe/capacity vs usage/transfer |
| **European Parliament** | Brokered cloud (Commission as broker); ingestion file-size and file-count limits shape pipeline design; FOCUS as interchange beats bespoke connector |

## Maturity tiering

| Maturity | Approach |
|---|---|
| **Crawl** | Stand up FOCUS exports; build one parallel report; reconcile manually for one billing period |
| **Walk** | Multi-consumer parallel run; Validator in CI; external allocation keys for stable orgs |
| **Run** | Automated reconciliation diffs in pipeline; FOCUS-canonical with provider-export shadow; v1.3+ adoption tracked |

## When FOCUS isn't ready

Some data generators don't yet support FOCUS. Options:

- Ask the account representative -- vendor advocacy moves the spec
  forward.
- Use the open-source `focus_converters`
  (<https://github.com/finopsfoundation/focus_converters>) to
  retroactively shape legacy data.
- Stand up FOCUS for the providers that do support it; run hybrid
  rather than waiting for full coverage.

## Iron Triangle

| Dimension | Effect |
|---|---|
| **Cost** | Parallel run costs more than a hard cut-over for the duration. Saves cost long-term (avoided trust failures, avoided reconciliation incidents). |
| **Speed** | Slower cut-over. Faster to actual stable adoption. |
| **Quality** | Reconciliation visibility is the quality. The legacy pipeline as a shadow is the quality. |
| **Carbon** | Negligible direct effect; FOCUS-driven allocation supports lower-carbon decisions over time. |

## Related

- [FOCUS Essentials](../doctrine/focus-essentials.md)
- [Crawl, Walk, Run](../doctrine/crawl-walk-run.md)
- [Data in the Path](../doctrine/data-in-the-path.md)
- Agent: `data-platforms/focus-data-engineer.md`
- Agent: `data-platforms/cost-warehouse-modeler.md`
- Agent: `cloud-cost/cloud-billing-analyst.md`
