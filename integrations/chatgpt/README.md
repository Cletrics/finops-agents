# ChatGPT / GPT / Codex integration

Three ways to use Cletrics FinOps Agents with OpenAI stack, depending on
which surface you're on.

---

## Codex CLI

Codex CLI uses the same `~/.codex/agents/*.md` format as Claude Code with
YAML frontmatter. No conversion needed.

```bash
./scripts/install.sh --tool codex
```

Agents land at `~/.codex/agents/cletrics-finops/`. Invoke by name in Codex
CLI the same way you would any other agent.

---

## ChatGPT web -- Custom GPT (Plus / Team / Enterprise)

ChatGPT custom GPTs give you ~8000 chars of instructions + up to 20 Knowledge
file uploads. We pre-build both.

### Option A: single-bundle Custom GPT (recommended)

1. Run the converter:
   ```bash
   ./scripts/convert.sh --tool chatgpt
   ```
2. Open ChatGPT, create a new GPT in **Configure** mode.
3. **Name**: "Cletrics FinOps Specialist"
4. **Instructions**: paste the contents of
   `integrations/chatgpt/cletrics-finops-bundle.md`. If it exceeds 8000
   chars, keep the header + specialist roster (the table of contents) -- the
   per-agent content is in Knowledge files.
5. **Knowledge**: upload every file from `integrations/chatgpt/knowledge/`
   (up to 20 at a time; split across multiple GPTs if you hit the cap).
6. **Capabilities**: enable Code Interpreter and Web Browsing. No custom
   actions needed.
7. **Conversation starters** (paste these):
   - "Audit last month's AWS cost increase using the AWS Cost Explorer Analyst."
   - "Is our Savings Plan coverage appropriate? Use the AWS Savings Plans Strategist."
   - "Find zombie resources in our environment using the Idle Resource Hunter."
   - "We just hit Cross-AZ Chatterbox -- walk me through the playbook."

### Option B: ChatGPT Projects (Plus+)

Projects let you scope uploaded files + instructions per project.

1. Create a Project named "FinOps".
2. Upload `cletrics-finops-bundle.md` + all `knowledge/*.md` files.
3. Set Project Instructions to the first section of the bundle (the
   routing rules).
4. All chats within the project inherit the specialists.

### Option C: plain ChatGPT session (free tier)

Paste the contents of one specific agent's file into the start of your
conversation. The model loads the persona for that session.

---

## Gemini (via Gemini CLI)

Gemini CLI uses a **skill directory** format (not a single-file agent).
The converter wraps each agent in a skill directory at
`integrations/gemini-cli/skills/<slug>/SKILL.md`.

```bash
./scripts/convert.sh --tool gemini-cli
./scripts/install.sh --tool gemini-cli
```

Skills land at `~/.gemini/skills/cletrics-finops/`. Activate a skill via
`activate_skill` in the Gemini CLI session.

---

## Gemini web (ai.google.com / Gem Builder)

Gems accept up to 8000 chars of instructions + Drive-attached context.

1. Open Gemini → Gem Builder.
2. **Instructions**: paste the `cletrics-finops-bundle.md` header + roster.
3. **Files**: upload `knowledge/*.md` files to Drive and attach.
4. Save as "Cletrics FinOps Specialist".

---

## Claude.ai web (Projects)

Claude Projects accept up to ~200k tokens of project knowledge. All 34
agents fit comfortably.

1. Create Project "Cletrics FinOps".
2. Upload every agent `.md` from category directories (or just the
   concatenated bundle).
3. Set Project Custom Instructions to the routing preamble from
   `cletrics-finops-bundle.md`.
