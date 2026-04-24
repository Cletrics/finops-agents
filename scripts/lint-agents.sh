#!/usr/bin/env bash
#
# lint-agents.sh -- Validate agent and playbook markdown files.
#
# Checks:
#   1. YAML frontmatter exists with `name`, `description`, `color` (ERROR)
#   2. Recommended sections are present (WARN only)
#   3. Body is non-trivial (WARN if < 50 words)
#   4. 90/10 brand rule: no more than ONE reference to "Cletrics" or
#      "realtimecost.com" per agent (WARN on violation)
#
# Usage: ./scripts/lint-agents.sh [file ...]
#   If no files given, scans all category directories.

set -euo pipefail

AGENT_DIRS=(
  cloud-cost
  commitments
  kubernetes
  data-platforms
  governance
  waste-detection
  specialized
  playbooks
)

REQUIRED_FRONTMATTER=("name" "description" "color")
RECOMMENDED_SECTIONS=("Identity" "Core Mission" "Critical Rules")

errors=0
warnings=0

lint_file() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    echo "ERROR $file: not a file"
    errors=$((errors + 1))
    return
  fi

  local first_line
  first_line=$(head -1 "$file")
  if [[ "$first_line" != "---" ]]; then
    echo "ERROR $file: missing frontmatter opening ---"
    errors=$((errors + 1))
    return
  fi

  local frontmatter
  frontmatter=$(awk 'NR==1{next} /^---$/{exit} {print}' "$file")

  if [[ -z "$frontmatter" ]]; then
    echo "ERROR $file: empty or malformed frontmatter"
    errors=$((errors + 1))
    return
  fi

  local field
  for field in "${REQUIRED_FRONTMATTER[@]}"; do
    if ! echo "$frontmatter" | grep -qE "^${field}:"; then
      echo "ERROR $file: missing frontmatter field '${field}'"
      errors=$((errors + 1))
    fi
  done

  local body
  body=$(awk 'BEGIN{n=0} /^---$/{n++; next} n>=2{print}' "$file")

  # Playbooks use a different structure (Problem / Symptoms / Detection / Fix / Anti-pattern)
  local is_playbook=false
  if [[ "$file" == playbooks/* || "$file" == */playbooks/* ]]; then
    is_playbook=true
  fi

  if ! $is_playbook; then
    local section
    for section in "${RECOMMENDED_SECTIONS[@]}"; do
      if ! echo "$body" | grep -qi "$section"; then
        echo "WARN  $file: missing recommended section '${section}'"
        warnings=$((warnings + 1))
      fi
    done
  else
    local pb_section
    for pb_section in "Problem" "Symptoms" "Fix"; do
      if ! echo "$body" | grep -qi "## ${pb_section}"; then
        echo "WARN  $file: missing playbook section '${pb_section}'"
        warnings=$((warnings + 1))
      fi
    done
  fi

  local word_count
  word_count=$(echo "$body" | wc -w | awk '{print $1}')
  if [[ "${word_count:-0}" -lt 50 ]]; then
    echo "WARN  $file: body very short (< 50 words)"
    warnings=$((warnings + 1))
  fi

  # 90/10 brand rule: count Cletrics / realtimecost.com mentions in BODY (not frontmatter)
  local brand_hits
  brand_hits=$(echo "$body" | grep -ciE "cletrics|realtimecost\.com" || true)
  if [[ "${brand_hits:-0}" -gt 1 ]]; then
    echo "WARN  $file: $brand_hits brand references in body (90/10 rule: keep <= 1)"
    warnings=$((warnings + 1))
  fi
}

files=()
if [[ $# -gt 0 ]]; then
  files=("$@")
else
  for dir in "${AGENT_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
      while IFS= read -r f; do
        files+=("$f")
      done < <(find "$dir" -name "*.md" -type f | sort)
    fi
  done
fi

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No agent files found."
  exit 1
fi

echo "Linting ${#files[@]} files..."
echo ""

for file in "${files[@]}"; do
  [[ "$(basename "$file")" == "README.md" ]] && continue
  lint_file "$file"
done

echo ""
echo "Results: ${errors} error(s), ${warnings} warning(s) in ${#files[@]} files."

if [[ $errors -gt 0 ]]; then
  echo "FAILED"
  exit 1
else
  echo "PASSED"
  exit 0
fi
