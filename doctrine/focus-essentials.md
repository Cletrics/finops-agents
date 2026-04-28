# Doctrine: FOCUS Essentials

> "FOCUS is the interface between cost-and-usage data producers and
> consumers. Both sides matter."
> -- Rıza, NEOS / Cloudway (FOCUS Analyst course)

The FinOps Open Cost & Usage Specification (FOCUS) standardizes billing
and usage data across cloud, SaaS, PaaS, and other consumption-based
services. Agents in this repo treat FOCUS as the default data shape
unless an agent is explicitly scoped to a single provider's native
export.

This doctrine captures the analyst-grade fundamentals every agent should
internalize. Full spec: <https://focus.finops.org/focus-specification/>

## The four cost columns -- pick the right one

Wrong column = wrong answer. Memorize this table.

| Column | What it includes | What it excludes | Use when |
|---|---|---|---|
| **Billed Cost** | All discounts, all reduced rates | Amortization of prepaid purchases | Cash-basis work: invoice reconciliation, budgeting, allocation |
| **Effective Cost** | All discounts + amortized prepaid portion attributable to this charge | (the original prepaid charge itself = $0) | Accrual-basis work: trend analysis, true resource attribution, chargeback |
| **List Cost** | List Unit Price × Pricing Quantity | Any discount | Measuring savings from rate optimization |
| **Contracted Cost** | Negotiated rate × Pricing Quantity | Commitment-based discounts | Measuring savings from commitments specifically |

**Critical**: aggregated **Effective Cost** for a billing period **may
not match** the invoice -- amortization spreads prepaid charges across
periods. **Billed Cost** is the column that ties to invoices.

**Savings math** (from the FOCUS Analyst course):
- Comparing **List → Effective** *overstates* savings (includes
  negotiated discounts you'd get anyway)
- Comparing **Contracted → Effective** isolates commitment savings
- Worked example: pre-purchased $1/hr VM with 30% commitment + 5%
  negotiated. List=$1.00, Contracted=$0.95, Effective=$0.70. Commitment
  savings = $0.95 − $0.70 = **$0.25** (not $0.30).

## Pricing Quantity ≠ Consumed Quantity

**Pricing Quantity** = what you're billed for (after block pricing,
tier rules).
**Consumed Quantity** = what you actually used.

If you charge for 1,000 hours but use 501, Pricing=1000 and Consumed=501.
Cost per hour using the wrong column reports $2.50 when you're paying
$5.00. Finance catches it. Credibility takes the hit.

Use Pricing Quantity for cost math; Consumed Quantity for utilization.

## Charge Class IS NULL = normal charge

Every analytical query should filter:
```sql
WHERE ChargeClass IS NULL
```
A null Charge Class is **intentional** -- it explicitly means "this is
a regular charge, not a correction to a prior period." Treating null as
a data-quality issue here is wrong; treating it as a correction is
wrong. Filter it explicitly to exclude retroactive adjustments from
trend analysis. Analyze corrections separately when needed.

## Aggregation double-counting

Reservations create both Purchase rows and Usage rows. Summing List
Cost across both double-counts. Always filter Charge Category before
aggregating List or Contracted Cost:

```sql
WHERE ChargeCategory = 'Usage'   -- or 'Purchase', not both
```

## Service Category > Service Name for cross-provider

`ServiceCategory` is normalized (Compute / Storage / Networking /
Databases / AI and Machine Learning / Analytics / Security / Other).
`ServiceName` is provider-specific.

Wrong: `ServiceName IN ('Amazon S3','Google Cloud Storage','Azure Blob')`
-- breaks the moment a new provider appears or names change.
Right: `ServiceCategory = 'Storage'` -- portable across all FOCUS
generators.

Same principle: `Category` columns are normalized, `Type` columns are
provider-defined. Filter on Category for portability, drill into Type
for provider specifics.

## Tags are JSON, finalized, immutable IDs vs mutable names

- `Tags` is a serialized JSON object (ECMA 404). Use JSON extraction
  functions, never `LIKE` on the raw column.
- Values must be: number, string, true, false, or null. **Not** an
  object or array.
- Tags are **finalized** at the provider before they appear in FOCUS
  data -- inheritance from account/folder/resource has already been
  resolved.
- **Resource ID** is immutable across billing periods; **Resource Name**
  may change. Always join on IDs, display Names. Same for Billing
  Account and Sub Account.

## Capacity Reservations ≠ Commitment Discounts

Different things, same row-level shape, often confused:

| | Commitment Discounts | Capacity Reservations |
|---|---|---|
| Provides | Pricing discount | Resource availability guarantee |
| You pay for | Discounted usage | Reserved capacity, regardless of consumption |
| Has Purchase rows? | Yes | **No** -- only Usage rows |
| Status column | `CommitmentDiscountStatus` (Used / Unused) | `CapacityReservationStatus` (Used / Unused) |

If you can't find Purchase rows for a capacity reservation, that's not
a bug -- they don't exist.

`Unused` rows count as waste **only after the consumption window has
closed**. Future windows aren't "unutilized yet."

## Provider / Publisher / Invoice Issuer = three distinct roles

For marketplace, reseller, and MSP scenarios:
- **Provider** -- who made it available (the marketplace, the MSP, the
  cloud account owner)
- **Publisher** -- who actually built the product (the SaaS vendor)
- **Invoice Issuer** -- who billed you for it

Filter on Publisher to see total spend with a software vendor across
all procurement channels. Filter on Invoice Issuer for invoice
reconciliation.

## Format requirements every analyst should know

- Column names: **Pascal case**, alphanumeric, no abbreviations except
  `Id` and `Sku`. SHOULD NOT exceed 50 chars.
- Currencies: **ISO 4217** three-letter alphabetic codes (`USD`, not
  `$`; `EUR`, not `€`).
- Timestamps: **ISO 8601 UTC** with `Z` suffix
  (`2026-01-01T00:00:00Z`). Not local time, not offset.
- Date ranges: **inclusive start, exclusive end**. A January billing
  period is `2026-01-01T00:00:00Z` ≤ t < `2026-02-01T00:00:00Z`.
- Numerics: single value, no separators, no symbols, no units inline.
  Negative sign allowed; positive sign forbidden.
- Nulls: explicit `NULL`, never `""` or `"N/A"` or placeholder zero.

## Filter discipline

- Prefer **normalized columns** over `LIKE` substring matching.
  Substring filters break silently when descriptions change.
- Negated filters (`WHERE x != value`) are a validation tool: run them
  alongside positive filters to see what's excluded.
- Always **validate over a small range first** (1 hour, LIMIT 100,
  manual cross-check), then expand.

## Pricing Category (normalized)

`PricingCategory` allowed values:
- **Standard** -- agreed-upon rate (incl. negotiated discounts and
  flat/volume/tiered pricing). Excludes dynamic and commitment.
- **Dynamic** -- variable rate set by provider (spot, low-priority).
- **Committed** -- reduced rate from an applied commitment discount.
- **Other** -- doesn't fit above.

Filter on `PricingCategory` to isolate optimization opportunities
(e.g., on-demand workloads eligible for commitment) without scraping
free-form text.

## Validator and Requirements Analyzer

The FinOps Foundation ships two open-source tools:

- **FOCUS Validator** -- <https://github.com/finopsfoundation/focus_validator>
  -- evaluates dataset conformance against the spec. Currently v1.2;
  v1.3/v1.4 planned.
- **Requirements Analyzer** -- searchable index of the 600+ normative
  requirements:
  <https://finops-open-cost-and-usage-spec.github.io/focus_requirements_model_analyzer/>

Use both during onboarding and after any provider schema change.
Validator caveat: some fields are conditionally required, so it may
flag false positives or miss field-level issues for your specific
scenario. A passing sample doesn't imply full-dataset conformance.

## Metadata: load before you query

Every FOCUS dataset must include schema metadata:
- `DataGenerator` -- who produced this
- `Schema ID`, `Creation Date`, `FOCUS Version`
- `Column Definition` per column: name, data type, precision/scale,
  string encoding/max length, provider tag prefixes

For cost columns, **precision 30 / scale 15** is a safe target -- you
work with many small numbers that aggregate to large numbers.

Provider tag prefixes are how you separate user-defined tags from
provider-defined ones in the `Tags` column.

## Versions in the wild (as of v1.2)

| Version | Released | Highlights |
|---|---|---|
| 1.0 | June 2024 | First production release; CSP billing baseline |
| 1.1 | -- | Capacity reservations, commitment discount detail, service subcategories, SKU detail |
| 1.2 | -- | **Cloud+ era**: SaaS+PaaS unified; Invoice ID; new account dimensions; virtual currency support |
| 1.3 | -- | Allocation transparency, contract dataset, freshness/completeness signals, Service vs Host Provider, first deprecations |

Don't wait for v1.3 to start applying FOCUS principles -- the columns
that exist in your version's data are still useful. Tell vendors which
versions you want supported.

## How agents should use this

Every agent that touches billing data, queries cost columns, or makes
cross-provider claims should:
1. Default examples to FOCUS column names and semantics.
2. Cite the right cost column for the question being asked
   (Billed/Effective/List/Contracted).
3. Always state which Charge Category, Charge Class, and Pricing
   Category filters apply.
4. Reference normalized columns first; fall back to provider-specific
   columns only when the FOCUS column doesn't exist.
5. Surface version awareness when relevant ("requires FOCUS 1.2+").

## Related

- [Iron Triangle](./iron-triangle.md)
- [Data in the Path](./data-in-the-path.md)
- [Crawl, Walk, Run](./crawl-walk-run.md)
- [FCP Canon Anchors](./fcp-anchors.md)
- Playbook: [FOCUS Adoption: Parallel Run](../playbooks/focus-adoption-parallel-run.md)
- FOCUS spec: <https://focus.finops.org/focus-specification/>
- Column library: <https://focus.finops.org/focus-columns/>
- Use Case library: <https://focus.finops.org/use-cases/>
- Adopting FOCUS paper:
  <https://www.finops.org/wg/adopting-focus-the-finops-open-cost-and-usage-specification/>
