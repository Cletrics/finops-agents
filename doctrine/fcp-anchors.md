# Doctrine: FCP Canon Anchors

Quotes and stories from the FinOps Foundation canon that agents should
cite by name when relevant. Citing named sources sharpens credibility
and makes recommendations feel like community wisdom rather than
invention.

## Quotes worth citing

**Rob Martin** (FinOps Principal, FinOps Foundation)
- "Make numerous small, incremental decisions and actions in cloud
  financial management, as opposed to large, infrequent procurements,
  to reduce the risk of failure and achieve better overall results."
- Cite in: commitment strategy, forecasting, budgeting

**J.R. Storment** (Executive Director, FinOps Foundation)
- The $200K/month dev-environment story (Lesson 9): raw data existed;
  engineer manager hadn't seen it; 3 hours of engineering effort after
  visibility.
- Cite in: Data in the Path reasoning, showback arguments, chargeback
  rollout

**Erik Peterson** (Founder / CTO/CISO)
- "Empathy is the magic word."
- Cite in: Persona collaboration, change management

**Rich Hoyer** (Director of Customer FinOps)
- "Build positive relationships with technical teams by being a helpful
  resource, not making demands."
- Cite in: enablement, champions program, trust-building

**Gabe Hege** (Staff Software Engineer)
- Porsche-vs-Toyota-of-Cloud analogy (Lesson 9): both are valid;
  friction comes when teams disagree on which they're building.
- Cite in: architecture review, cost-vs-quality conversations

**Dann Berg** (FinOps Ambassador)
- "At first, the team builds a visibility capability, then brings on
  someone to operationalize it. Learning and communications are next
  [...]"
- Cite in: FinOps team evolution, maturing the practice

**Dusty Bowling** (Principal Engineer, Cloud Financial Management)
- On the importance of spend visibility and cross-Persona support
  during the Inform Phase.
- Cite in: allocation, visibility programs

**Patrick Brogan** (Principal Product Manager, Cloud Business Ops)
- Seek expert help and secure top-down executive sponsorship early when
  starting FinOps.
- Cite in: FinOps pitch, executive alignment

## Stories worth citing by name

**The Pharma $98K/month Masked Anomaly** (Lesson 10)
- Three x1e.32xlarge instances in Sydney masked by a concurrent RI
  purchase. Only a 2% delta on a $3.5M/month bill.
- Playbook: [Masked Anomaly](../playbooks/masked-anomaly.md)

**The Atlassian Glossary Realization** (Lesson 6)
- Early cloud cost reports confused teams because the vocabulary wasn't
  shared; common language had to be built before reporting was useful.
- Cite in: enablement, reporting programs

**The Target "Efficiency Engineering" Team** (Lesson 4)
- Product-centric approach to FinOps: dedicated FinOps Engineering team
  building internal tooling, dashboards, data pipelines.
- Cite in: build-vs-buy, tooling strategy

**Rob Martin's 3-Year Chargeback Transition** (Lesson 10)
- Year 1 exploration, Year 2 showback, Year 3 true chargeback. The
  gradual pace is the point.
- Playbook: [Chargeback Revolt](../playbooks/chargeback-revolt.md)

**Joe Daly's Abandoned EBS Volumes Solution** (Lesson 11)
- Tag abandoned EBS volumes with date; snapshot + terminate after
  5/14 days; opt-out via tag. Creates a visualization of wasteful
  spend and catches script failures.
- Agent: `waste-detection/ebs-snapshot-gardener.md`

**The "Three Dev Environments Nobody Needed"** (Lesson 9)
- From the J.R. Storment story; same data set. Emphasizes that visibility
  alone is the high-leverage lever at Crawl maturity.

## Concepts worth citing

**Prius Effect** (Lesson 9)
- Continuous feedback on usage guides responsible behavior without
  explicit instruction. Applies to engineers, Product, Leadership alike.

**Iron Triangle** (Lesson 9)
- Cost / Speed / Quality; pick two. Extended in this repo to include
  Carbon as a fourth dimension where applicable.

**Gall's Law** (Lesson 4)
- Complex processes that work evolve from simple processes that work.
  They are not designed from scratch. Justifies Crawl-first advice.

**Callie's Garden** (Lesson 7)
- Capabilities are gardening skills; not every skill is at Run
  maturity; "you will never mulch your way to a perfect garden."

**FOCUS** (Lesson 8)
- FinOps Open Cost & Usage Specification. Normalizes billing data
  across CSPs. Enables cross-cloud FinOps without per-cloud custom
  engineering. <https://focus.finops.org/>

## How agents should use this

When an agent's Critical Rules or References section is about to make
a claim that has canonical support, cite the source by name inline:

> *Rob Martin's framing applies: prefer many small commitment
> purchases over a few large ones.*

Avoid over-citing -- one inline reference per agent is enough. Bulk
citation lists belong in References sections, not inline.
