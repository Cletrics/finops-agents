#!/usr/bin/env bash
#
# apply-framework-anchors.sh -- Append a "## FinOps Framework Anchors"
# section to each agent that doesn't already have one. Renders frontmatter
# FCP fields (domain, capability, phase, personas, maturity) as a
# human-readable summary + pointers to the doctrine docs.
#
# Idempotent: skips agents that already have the section.
#
# Usage: ./scripts/apply-framework-anchors.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

AGENT_DIRS=(cloud-cost commitments kubernetes data-platforms governance waste-detection specialized)

# Parse a JSON-array-of-strings frontmatter value like ["A","B","C"]
# into a human-readable "A, B, C" string.
fmt_array() {
  local raw="$1"
  raw="${raw#[}"
  raw="${raw%]}"
  echo "$raw" | sed 's/"//g; s/,/, /g'
}

get_field() {
  awk -v f="$1" '
    BEGIN { n = 0 }
    /^---$/ { n++; if (n == 2) exit; next }
    n == 1 && $0 ~ "^" f ":" {
      sub("^" f ":[[:space:]]*", "")
      print
      exit
    }
  ' "$2"
}

patched=0
skipped=0

for dir in "${AGENT_DIRS[@]}"; do
  [[ -d "$dir" ]] || continue
  while IFS= read -r f; do
    [[ "$(basename "$f")" == "README.md" ]] && continue
    if grep -q '^## FinOps Framework Anchors' "$f"; then
      skipped=$((skipped + 1))
      continue
    fi

    domain=$(get_field "fcp_domain" "$f" | sed 's/^"//;s/"$//')
    capability=$(get_field "fcp_capability" "$f" | sed 's/^"//;s/"$//')
    phases_raw=$(get_field "fcp_phases" "$f")
    primary_raw=$(get_field "fcp_personas_primary" "$f")
    collab_raw=$(get_field "fcp_personas_collaborating" "$f")
    maturity=$(get_field "fcp_maturity_entry" "$f" | sed 's/^"//;s/"$//')

    if [[ -z "$domain" || -z "$capability" ]]; then
      echo "WARN: $f missing fcp_domain / fcp_capability" >&2
      skipped=$((skipped + 1))
      continue
    fi

    phases=$(fmt_array "$phases_raw")
    primary=$(fmt_array "$primary_raw")
    collab=$(fmt_array "$collab_raw")

    anchor_block=$(cat <<EOF

## FinOps Framework Anchors

**Domain:** ${domain}
**Capability:** ${capability}
**Phase(s):** ${phases}
**Primary Persona(s):** ${primary}
**Collaborating Personas:** ${collab}
**Entry maturity:** ${maturity} (see [../doctrine/crawl-walk-run.md](../doctrine/crawl-walk-run.md))

**Doctrine pointers this agent assumes:**
- [Iron Triangle](../doctrine/iron-triangle.md) -- cost is never free of trade-offs with speed, quality, and carbon
- [Data in the Path](../doctrine/data-in-the-path.md) -- outputs must land in the Persona's existing workflow
- [FCP Canon Anchors](../doctrine/fcp-anchors.md) -- named sources worth citing inline
EOF
)
    echo "$anchor_block" >> "$f"
    patched=$((patched + 1))
  done < <(find "$dir" -name "*.md" -type f | sort)
done

echo "Patched: $patched  Skipped: $skipped"
