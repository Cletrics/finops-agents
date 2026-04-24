# Doctrine: Crawl, Walk, Run

Maturity in the FinOps Framework is **per-Capability**, not per-org.
An organization can be at Run in Rate Optimization and still at Crawl
in Benchmarking. Framework-aligned advice respects that.

## Definitions (from FCP Lesson 4)

**Crawl**
- Very little reporting and tooling
- Measurements only provide insight into the benefits of maturing the
  Capability
- Basic KPIs set for success measurement
- Basic processes and policies defined
- Capability is understood but not followed by all major teams
- Plans to address "low-hanging fruit"

**Walk**
- Capability is understood and followed within the organization
- Difficult edge cases are identified; some explicitly deferred
- Automation and/or processes cover most Capability requirements
- Most business-critical edge cases have remediation estimates
- Medium-to-high goals / KPIs set on success measurement

**Run**
- Capability is understood and followed by all teams
- Difficult edge cases are being addressed
- Very high goals / KPIs on success measurement
- Automation is the preferred approach

## How agents should use this

Every agent should tier its recommendations by maturity. Not every
recommendation applies at every level. Format inside Critical Rules or
Technical Deliverables:

> **Maturity tiering:**
> - **Crawl:** [simplest useful approach, often manual]
> - **Walk:** [structured, semi-automated approach]
> - **Run:** [fully automated, integrated, policy-enforced approach]

Agents should also state their **entry maturity level** in frontmatter
(`fcp_maturity_entry`). Below that level, the agent is premature; the
org needs something more foundational first.

## Key FCP insight (often forgotten)

> "If you are in the Run maturity and it is not adding value, you may
> be wasting a most precious resource: time."

Don't push every Capability to Run. Push each Capability to the
maturity that the business value warrants. Some Capabilities can sit
at Crawl forever -- that's fine.

## Anti-patterns

- **Universal Run recommendations.** "You should automate everything"
  is cheap advice that ignores operational cost.
- **Crawl-only thinking at Run-maturity orgs.** Teams ready for
  automated driver-based forecasting don't need spreadsheet advice.
- **Skipping Walk.** Jumping from Crawl to Run without a Walk phase is
  how chargeback revolts, failed automations, and Day-2 operational
  debt happen.

## Related

- FCP Lesson 4 -- FinOps Framework overview
- Agent: `governance/finops-practice-maturity-assessor.md`
- Playbook: [Chargeback Revolt](../playbooks/chargeback-revolt.md)
