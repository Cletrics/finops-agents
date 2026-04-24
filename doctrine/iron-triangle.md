# Doctrine: The Iron Triangle

> "Good, fast, or cheap. Pick two."

Every cost recommendation trades off against something else. FCP Lesson 9
is explicit: trade-offs are not side effects of optimization, they are
the *substance* of optimization. Ignoring them produces recommendations
that get rejected as soon as the second-order effects are felt.

## The four dimensions

Standard Iron Triangle is Cost / Speed / Quality. In the FinOps
Framework the implicit fourth dimension is **carbon / sustainability**.
For optimization recommendations that affect the environment (region
choice, workload scheduling, instance family), include all four.

| Dimension | What it means |
|---|---|
| **Cost** | Monthly / annual dollars |
| **Speed** | Time-to-ship, time-to-iterate, deployment velocity |
| **Quality** | Reliability, latency, durability, observability depth |
| **Carbon** | CO2e per unit of work; region and efficiency |

## How agents should use this

Every recommendation-producing agent should close its Core Mission or
Critical Rules section with an explicit trade-off statement. Format:

> **Iron Triangle.** This recommendation moves **cost ↓** by
> [amount], at the expense of **speed ↓** by [amount] and **quality →**
> unchanged. The engineer picks; you quantify.

Some cases are trade-off-free (a zombie NAT Gateway nobody uses costs
nothing to remove). When the trade-off really is trivial, say so
explicitly -- don't invent one.

## Anti-patterns

- **Recommendations framed as "better" or "best."** Better along which
  axis? If the answer is "just cost" in a business that depends on
  reliability, the recommendation is weaker than it reads.
- **Hiding latency regressions in rightsizing.** Rightsizing nearly
  always trades some quality (headroom, latency, tail behavior) for
  cost. Surface it.
- **Ignoring migration cost.** "Switch to Graviton saves 20%" ignores
  the engineering time to revalidate. Name it.

## Related

- FCP Lesson 9 -- Data in the Path (the full trade-off rationale)
- [Data in the Path doctrine](./data-in-the-path.md)
- Agent: `governance/sre-slo-cost-tradeoff.md`
