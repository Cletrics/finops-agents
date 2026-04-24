#!/usr/bin/env bash
#
# fcp-coverage.sh -- Report which FinOps Certified Practitioner (FCP)
# Framework Capabilities are covered by agents in the roster, and which
# remain as gaps.
#
# Reads fcp_domain + fcp_capability fields from agent frontmatter and
# compares against the canonical 18-Capability set from the FCP course
# (Lesson 7 Domains & Capabilities).
#
# Usage: ./scripts/fcp-coverage.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# Canonical FCP Framework Domains and Capabilities
declare -A CANONICAL
CANONICAL["Understand Usage & Cost"]="Data Ingestion|Allocation|Reporting & Analytics|Anomaly Management"
CANONICAL["Quantify Business Value"]="Planning & Estimating|Forecasting|Budgeting|Benchmarking|Unit Economics"
CANONICAL["Optimize Usage & Cost"]="Architecting for Cloud|Rate Optimization|Workload Optimization|Cloud Sustainability|Licensing & SaaS"
CANONICAL["Manage the FinOps Practice"]="FinOps Practice Operations|Policy & Governance|FinOps Assessment|FinOps Tools & Services|FinOps Education & Enablement|Invoicing & Chargeback|Onboarding Workloads|Intersecting Disciplines"

AGENT_DIRS=(cloud-cost commitments kubernetes data-platforms governance waste-detection specialized)

# Collect covered capabilities: "Domain||Capability" -> list of agents
declare -A COVERAGE

for dir in "${AGENT_DIRS[@]}"; do
  [[ -d "$dir" ]] || continue
  while IFS= read -r f; do
    [[ "$(basename "$f")" == "README.md" ]] && continue
    domain=$(awk -F'"' '/^fcp_domain:/ {print $2; exit}' "$f")
    capability=$(awk -F'"' '/^fcp_capability:/ {print $2; exit}' "$f")
    name=$(awk -F'"' '/^name:/ && !/^fcp_/ {sub(/^name: /,""); print; exit}' "$f" | sed 's/^"//;s/"$//')
    [[ -z "$domain" || -z "$capability" ]] && continue
    key="${domain}||${capability}"
    if [[ -n "${COVERAGE[$key]:-}" ]]; then
      COVERAGE[$key]="${COVERAGE[$key]}; ${name}"
    else
      COVERAGE[$key]="${name}"
    fi
  done < <(find "$dir" -name "*.md" -type f)
done

# Print coverage matrix
total_caps=0
covered_caps=0

printf "\n# FCP Framework Coverage Matrix\n\n"
printf "Source: FCP course Lesson 7 -- 4 Domains, 18 canonical Capabilities.\n\n"

for domain in "Understand Usage & Cost" "Quantify Business Value" "Optimize Usage & Cost" "Manage the FinOps Practice"; do
  printf "## %s\n\n" "$domain"
  IFS='|' read -ra caps <<< "${CANONICAL[$domain]}"
  for cap in "${caps[@]}"; do
    total_caps=$((total_caps + 1))
    key="${domain}||${cap}"
    if [[ -n "${COVERAGE[$key]:-}" ]]; then
      covered_caps=$((covered_caps + 1))
      printf -- "- [x] **%s** -- %s\n" "$cap" "${COVERAGE[$key]}"
    else
      printf -- "- [ ] **%s** -- (no agent)\n" "$cap"
    fi
  done
  printf "\n"
done

printf -- "---\n\n"
printf "**Coverage: %d / %d Framework Capabilities** (%.0f%%)\n\n" \
  "$covered_caps" "$total_caps" \
  "$(awk -v c="$covered_caps" -v t="$total_caps" 'BEGIN {printf "%.0f", (c/t)*100}')"

# Gap list for README/docs
if [[ "$covered_caps" -lt "$total_caps" ]]; then
  printf "## Roadmap candidates (uncovered Capabilities)\n\n"
  for domain in "Understand Usage & Cost" "Quantify Business Value" "Optimize Usage & Cost" "Manage the FinOps Practice"; do
    IFS='|' read -ra caps <<< "${CANONICAL[$domain]}"
    for cap in "${caps[@]}"; do
      key="${domain}||${cap}"
      if [[ -z "${COVERAGE[$key]:-}" ]]; then
        printf -- "- %s: **%s**\n" "$domain" "$cap"
      fi
    done
  done
  printf "\n"
fi
