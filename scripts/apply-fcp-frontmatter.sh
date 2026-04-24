#!/usr/bin/env bash
#
# apply-fcp-frontmatter.sh -- One-shot script. Inserts FCP Framework alignment
# fields into each agent's YAML frontmatter. Idempotent: skips files that
# already have `fcp_domain:`.
#
# Maps each agent to its FinOps Certified Practitioner (FCP) Framework
# anchors: Domain, Capability, Phase(s), primary + collaborating Personas,
# and lowest useful Maturity level.
#
# Usage: ./scripts/apply-fcp-frontmatter.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# Mapping: relative_path|domain|capability|phases|primary_personas|collab_personas|maturity_entry
# Phases/Personas are JSON-array strings (no spaces inside).
MAPPING=$(cat <<'EOF'
cloud-cost/aws-cost-explorer-analyst.md|Understand Usage & Cost|Reporting & Analytics|["Inform"]|["FinOps Practitioner"]|["Finance","Engineering","Leadership"]|Crawl
cloud-cost/gcp-billing-interpreter.md|Understand Usage & Cost|Reporting & Analytics|["Inform"]|["FinOps Practitioner"]|["Finance","Engineering"]|Crawl
cloud-cost/azure-cost-management-navigator.md|Understand Usage & Cost|Reporting & Analytics|["Inform"]|["FinOps Practitioner"]|["Finance","Engineering","Leadership"]|Crawl
cloud-cost/multi-cloud-cost-comparator.md|Understand Usage & Cost|Reporting & Analytics|["Inform"]|["FinOps Practitioner"]|["Leadership","Finance","Engineering"]|Walk
cloud-cost/cost-anomaly-detector.md|Understand Usage & Cost|Anomaly Management|["Inform","Operate"]|["FinOps Practitioner"]|["Engineering","Finance"]|Crawl
cloud-cost/forecast-model-builder.md|Quantify Business Value|Forecasting|["Inform","Optimize"]|["FinOps Practitioner"]|["Finance","Product","Engineering"]|Crawl
cloud-cost/unit-economics-modeler.md|Quantify Business Value|Unit Economics|["Inform","Optimize"]|["FinOps Practitioner"]|["Product","Finance","Engineering"]|Walk
cloud-cost/budget-alert-tuner.md|Quantify Business Value|Budgeting|["Operate"]|["FinOps Practitioner"]|["Finance","Engineering"]|Crawl
commitments/aws-savings-plans-strategist.md|Optimize Usage & Cost|Rate Optimization|["Optimize"]|["FinOps Practitioner"]|["Finance","Procurement","Engineering"]|Walk
commitments/aws-reserved-instance-optimizer.md|Optimize Usage & Cost|Rate Optimization|["Optimize"]|["FinOps Practitioner"]|["Finance","Procurement","Engineering"]|Walk
commitments/gcp-cud-optimizer.md|Optimize Usage & Cost|Rate Optimization|["Optimize"]|["FinOps Practitioner"]|["Finance","Procurement","Engineering"]|Walk
commitments/azure-reservation-planner.md|Optimize Usage & Cost|Rate Optimization|["Optimize"]|["FinOps Practitioner"]|["Finance","Procurement","Engineering"]|Walk
commitments/edp-negotiation-coach.md|Optimize Usage & Cost|Rate Optimization|["Optimize","Operate"]|["FinOps Practitioner","Procurement"]|["Finance","Leadership"]|Walk
kubernetes/kubernetes-finops-engineer.md|Understand Usage & Cost|Allocation|["Inform"]|["FinOps Practitioner"]|["Engineering"]|Walk
kubernetes/container-rightsizer.md|Optimize Usage & Cost|Workload Optimization|["Optimize"]|["Engineering"]|["FinOps Practitioner"]|Walk
kubernetes/cluster-autoscaler-tuner.md|Optimize Usage & Cost|Workload Optimization|["Optimize"]|["Engineering"]|["FinOps Practitioner"]|Walk
data-platforms/cur-focus-data-engineer.md|Understand Usage & Cost|Data Ingestion|["Inform"]|["Engineering"]|["FinOps Practitioner"]|Walk
data-platforms/billing-data-pipeline-architect.md|Understand Usage & Cost|Data Ingestion|["Inform"]|["Engineering"]|["FinOps Practitioner"]|Walk
data-platforms/cost-warehouse-modeler.md|Understand Usage & Cost|Data Ingestion|["Inform"]|["Engineering"]|["FinOps Practitioner"]|Walk
governance/showback-chargeback-architect.md|Manage the FinOps Practice|Invoicing & Chargeback|["Inform","Operate"]|["FinOps Practitioner"]|["Finance","Leadership"]|Walk
governance/tag-hygiene-enforcer.md|Understand Usage & Cost|Allocation|["Inform"]|["FinOps Practitioner"]|["Engineering"]|Crawl
governance/finops-governance-lead.md|Manage the FinOps Practice|FinOps Practice Operations|["Operate"]|["FinOps Practitioner"]|["Leadership"]|Walk
governance/finops-practice-maturity-assessor.md|Manage the FinOps Practice|FinOps Assessment|["Operate"]|["FinOps Practitioner"]|["Leadership"]|Walk
governance/platform-team-cost-lead.md|Manage the FinOps Practice|FinOps Practice Operations|["Operate"]|["Engineering"]|["FinOps Practitioner"]|Walk
governance/sre-slo-cost-tradeoff.md|Optimize Usage & Cost|Architecting for Cloud|["Optimize","Operate"]|["Engineering"]|["FinOps Practitioner","Product"]|Walk
waste-detection/idle-resource-hunter.md|Optimize Usage & Cost|Workload Optimization|["Optimize"]|["Engineering"]|["FinOps Practitioner"]|Crawl
waste-detection/zombie-nat-gateway-detector.md|Optimize Usage & Cost|Workload Optimization|["Optimize"]|["Engineering"]|["FinOps Practitioner"]|Crawl
waste-detection/ebs-snapshot-gardener.md|Optimize Usage & Cost|Workload Optimization|["Optimize"]|["Engineering"]|["FinOps Practitioner"]|Crawl
waste-detection/s3-storage-class-auditor.md|Optimize Usage & Cost|Workload Optimization|["Optimize"]|["Engineering"]|["FinOps Practitioner"]|Crawl
waste-detection/cross-az-egress-investigator.md|Optimize Usage & Cost|Architecting for Cloud|["Inform","Optimize"]|["Engineering"]|["FinOps Practitioner"]|Walk
waste-detection/orphaned-load-balancer-hunter.md|Optimize Usage & Cost|Workload Optimization|["Optimize"]|["Engineering"]|["FinOps Practitioner"]|Crawl
specialized/ml-workload-cost-optimizer.md|Optimize Usage & Cost|Workload Optimization|["Optimize"]|["Engineering"]|["FinOps Practitioner","Product"]|Walk
specialized/serverless-cost-profiler.md|Optimize Usage & Cost|Architecting for Cloud|["Optimize"]|["Engineering"]|["FinOps Practitioner"]|Walk
specialized/spot-orchestrator.md|Optimize Usage & Cost|Rate Optimization|["Optimize"]|["Engineering"]|["FinOps Practitioner"]|Walk
EOF
)

patched=0
skipped=0

while IFS='|' read -r path domain capability phases primary collab maturity; do
  [[ -z "$path" ]] && continue
  if [[ ! -f "$path" ]]; then
    echo "WARN: $path not found" >&2
    continue
  fi
  if grep -q '^fcp_domain:' "$path"; then
    skipped=$((skipped + 1))
    continue
  fi

  fcp_block="fcp_domain: \"${domain}\"
fcp_capability: \"${capability}\"
fcp_phases: ${phases}
fcp_personas_primary: ${primary}
fcp_personas_collaborating: ${collab}
fcp_maturity_entry: \"${maturity}\""

  tmp="$(mktemp)"
  awk -v block="$fcp_block" '
    BEGIN { n = 0; inserted = 0 }
    /^---$/ {
      n++
      if (n == 2 && !inserted) {
        print block
        inserted = 1
      }
    }
    { print }
  ' "$path" > "$tmp"
  mv "$tmp" "$path"
  patched=$((patched + 1))
done <<< "$MAPPING"

echo "Patched: $patched  Skipped (already had fcp_*): $skipped"
