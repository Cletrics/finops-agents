#!/usr/bin/env bash
#
# install.sh -- Install Cletrics FinOps agents into your local agentic tool(s).
#
# Usage:
#   ./scripts/install.sh [--tool <name>] [--no-interactive] [--help]
#
# Tools:
#   claude-code  -- Copy agents to ~/.claude/agents/cletrics-finops/
#   codex        -- Copy agents to ~/.codex/agents/cletrics-finops/ (OpenAI Codex CLI)
#   gemini-cli   -- Copy agents as skills to ~/.gemini/skills/cletrics-finops/
#   copilot      -- Copy agents to ~/.github/agents/ and ~/.copilot/agents/
#   cursor       -- Copy rules to .cursor/rules/ in current directory
#   windsurf     -- Copy .windsurfrules to current directory
#   opencode     -- Copy agents to .opencode/agents/ in current directory
#   aider        -- Copy CONVENTIONS-finops.md to current directory
#   chatgpt      -- Print bundle path for Custom GPT / Project upload
#   all          -- Install for all detected tools (default)
#
# This script only performs local file copies. No network, no sudo, no eval.

set -euo pipefail

if [[ -t 1 && -z "${NO_COLOR:-}" && "${TERM:-}" != "dumb" ]]; then
  C_GREEN=$'\033[0;32m'; C_YELLOW=$'\033[1;33m'; C_RED=$'\033[0;31m'
  C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'; C_RESET=$'\033[0m'
else
  C_GREEN=''; C_YELLOW=''; C_RED=''; C_BOLD=''; C_DIM=''; C_RESET=''
fi

ok()   { printf "${C_GREEN}[OK]${C_RESET}  %s\n" "$*"; }
warn() { printf "${C_YELLOW}[!!]${C_RESET}  %s\n" "$*"; }
err()  { printf "${C_RED}[ERR]${C_RESET} %s\n" "$*" >&2; }
dim()  { printf "${C_DIM}%s${C_RESET}\n" "$*"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

ALL_TOOLS=(claude-code codex gemini-cli copilot cursor windsurf opencode aider chatgpt)

AGENT_DIRS=(
  cloud-cost commitments kubernetes data-platforms governance waste-detection specialized
)

usage() { sed -n '3,16p' "$0" | sed 's/^# \{0,1\}//'; exit 0; }

detect_claude_code() { [[ -d "${HOME}/.claude" ]]; }
detect_codex()       { command -v codex >/dev/null 2>&1 || [[ -d "${HOME}/.codex" ]]; }
detect_gemini_cli()  { command -v gemini >/dev/null 2>&1 || [[ -d "${HOME}/.gemini" ]]; }
detect_copilot()     { command -v code >/dev/null 2>&1 || [[ -d "${HOME}/.github" || -d "${HOME}/.copilot" ]]; }
detect_cursor()      { command -v cursor >/dev/null 2>&1 || [[ -d "${HOME}/.cursor" ]]; }
detect_windsurf()    { command -v windsurf >/dev/null 2>&1 || [[ -d "${HOME}/.codeium" ]]; }
detect_opencode()    { command -v opencode >/dev/null 2>&1 || [[ -d "${HOME}/.config/opencode" ]]; }
detect_aider()       { command -v aider >/dev/null 2>&1; }
detect_chatgpt()     { return 1; }  # web-only: never auto-selected, must pass --tool chatgpt

is_detected() {
  case "$1" in
    claude-code) detect_claude_code ;;
    codex)       detect_codex       ;;
    gemini-cli)  detect_gemini_cli  ;;
    copilot)     detect_copilot     ;;
    cursor)      detect_cursor      ;;
    windsurf)    detect_windsurf    ;;
    opencode)    detect_opencode    ;;
    aider)       detect_aider       ;;
    chatgpt)     detect_chatgpt     ;;
    *)           return 1 ;;
  esac
}

# ---- installers ----

install_claude_code() {
  local dest="${HOME}/.claude/agents/cletrics-finops"
  local count=0
  mkdir -p "$dest"
  local dir f first_line
  for dir in "${AGENT_DIRS[@]}"; do
    [[ -d "$REPO_ROOT/$dir" ]] || continue
    while IFS= read -r -d '' f; do
      first_line="$(head -1 "$f")"
      [[ "$first_line" == "---" ]] || continue
      cp "$f" "$dest/"
      (( count++ )) || true
    done < <(find "$REPO_ROOT/$dir" -name "*.md" -type f -not -name "README.md" -print0)
  done
  ok "Claude Code: $count agents -> $dest"
}

install_codex() {
  local dest="${HOME}/.codex/agents/cletrics-finops"
  local count=0
  mkdir -p "$dest"
  local dir f first_line
  for dir in "${AGENT_DIRS[@]}"; do
    [[ -d "$REPO_ROOT/$dir" ]] || continue
    while IFS= read -r -d '' f; do
      first_line="$(head -1 "$f")"
      [[ "$first_line" == "---" ]] || continue
      cp "$f" "$dest/"
      (( count++ )) || true
    done < <(find "$REPO_ROOT/$dir" -name "*.md" -type f -not -name "README.md" -print0)
  done
  ok "Codex CLI: $count agents -> $dest"
}

install_gemini_cli() {
  local src="$REPO_ROOT/integrations/gemini-cli/skills"
  local dest="${HOME}/.gemini/skills/cletrics-finops"
  [[ -d "$src" ]] || { err "integrations/gemini-cli missing. Run ./scripts/convert.sh first."; return 1; }
  mkdir -p "$dest"
  local d count=0
  while IFS= read -r -d '' d; do
    cp -r "$d" "$dest/"
    (( count++ )) || true
  done < <(find "$src" -maxdepth 1 -mindepth 1 -type d -print0)
  ok "Gemini CLI: $count skills -> $dest"
}

install_chatgpt() {
  local bundle="$REPO_ROOT/integrations/chatgpt/cletrics-finops-bundle.md"
  local knowledge_dir="$REPO_ROOT/integrations/chatgpt/knowledge"
  [[ -f "$bundle" ]] || { err "integrations/chatgpt missing. Run ./scripts/convert.sh first."; return 1; }
  ok "ChatGPT bundle ready:"
  dim "  Paste into Custom GPT / Project instructions:"
  dim "    $bundle"
  dim "  Or upload knowledge files (one per agent):"
  dim "    $knowledge_dir/"
  dim "  See integrations/chatgpt/README.md for full setup."
}

install_copilot() {
  local dest_gh="${HOME}/.github/agents"
  local dest_cp="${HOME}/.copilot/agents"
  local count=0
  mkdir -p "$dest_gh" "$dest_cp"
  local dir f first_line
  for dir in "${AGENT_DIRS[@]}"; do
    [[ -d "$REPO_ROOT/$dir" ]] || continue
    while IFS= read -r -d '' f; do
      first_line="$(head -1 "$f")"
      [[ "$first_line" == "---" ]] || continue
      cp "$f" "$dest_gh/"
      cp "$f" "$dest_cp/"
      (( count++ )) || true
    done < <(find "$REPO_ROOT/$dir" -name "*.md" -type f -not -name "README.md" -print0)
  done
  ok "Copilot: $count agents -> $dest_gh"
  ok "Copilot: $count agents -> $dest_cp"
}

install_cursor() {
  local src="$REPO_ROOT/integrations/cursor/rules"
  local dest="${PWD}/.cursor/rules"
  [[ -d "$src" ]] || { err "integrations/cursor missing. Run ./scripts/convert.sh first."; return 1; }
  mkdir -p "$dest"
  local f count=0
  while IFS= read -r -d '' f; do
    cp "$f" "$dest/"
    (( count++ )) || true
  done < <(find "$src" -maxdepth 1 -name "*.mdc" -print0)
  ok "Cursor: $count rules -> $dest"
  warn "Cursor: project-scoped. Run from your project root."
}

install_windsurf() {
  local src="$REPO_ROOT/integrations/windsurf/.windsurfrules"
  local dest="${PWD}/.windsurfrules"
  [[ -f "$src" ]] || { err "integrations/windsurf missing. Run ./scripts/convert.sh first."; return 1; }
  if [[ -f "$dest" ]]; then
    warn "Windsurf: .windsurfrules already exists at $dest (remove to reinstall)"
    return 0
  fi
  cp "$src" "$dest"
  ok "Windsurf: -> $dest"
}

install_opencode() {
  local src="$REPO_ROOT/integrations/opencode/agents"
  local dest="${PWD}/.opencode/agents"
  [[ -d "$src" ]] || { err "integrations/opencode missing. Run ./scripts/convert.sh first."; return 1; }
  mkdir -p "$dest"
  local f count=0
  while IFS= read -r -d '' f; do
    cp "$f" "$dest/"
    (( count++ )) || true
  done < <(find "$src" -maxdepth 1 -name "*.md" -print0)
  ok "OpenCode: $count agents -> $dest"
}

install_aider() {
  local src="$REPO_ROOT/integrations/aider/CONVENTIONS-finops.md"
  local dest="${PWD}/CONVENTIONS-finops.md"
  [[ -f "$src" ]] || { err "integrations/aider missing. Run ./scripts/convert.sh first."; return 1; }
  if [[ -f "$dest" ]]; then
    warn "Aider: $dest already exists (remove to reinstall)"
    return 0
  fi
  cp "$src" "$dest"
  ok "Aider: -> $dest"
}

install_tool() {
  case "$1" in
    claude-code) install_claude_code ;;
    codex)       install_codex       ;;
    gemini-cli)  install_gemini_cli  ;;
    copilot)     install_copilot     ;;
    cursor)      install_cursor      ;;
    windsurf)    install_windsurf    ;;
    opencode)    install_opencode    ;;
    aider)       install_aider       ;;
    chatgpt)     install_chatgpt     ;;
  esac
}

main() {
  local tool="all"
  local interactive_mode="auto"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --tool)           tool="${2:?'--tool requires a value'}"; shift 2; interactive_mode="no" ;;
      --no-interactive) interactive_mode="no"; shift ;;
      --help|-h)        usage ;;
      *)                err "Unknown option: $1"; usage ;;
    esac
  done

  if [[ "$tool" != "all" ]]; then
    local valid=false t
    for t in "${ALL_TOOLS[@]}"; do [[ "$t" == "$tool" ]] && valid=true && break; done
    if ! $valid; then err "Unknown tool '$tool'. Valid: ${ALL_TOOLS[*]}"; exit 1; fi
  fi

  printf "\n${C_BOLD}Cletrics FinOps Agents -- Installer${C_RESET}\n\n"

  local selected=()
  if [[ "$tool" != "all" ]]; then
    selected=("$tool")
  else
    local t
    for t in "${ALL_TOOLS[@]}"; do
      if is_detected "$t" 2>/dev/null; then
        selected+=("$t")
        printf "  ${C_GREEN}[*]${C_RESET} %s detected\n" "$t"
      else
        printf "  ${C_DIM}[ ] %s not found${C_RESET}\n" "$t"
      fi
    done
  fi

  if [[ ${#selected[@]} -eq 0 ]]; then
    warn "No tools selected or detected. Nothing to install."
    exit 0
  fi

  printf "\n"
  local t
  for t in "${selected[@]}"; do
    install_tool "$t"
  done

  printf "\n"
  ok "Done. Installed for: ${selected[*]}"
  dim "  See README.md for agent roster and usage."
}

main "$@"
