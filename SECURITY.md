# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly.
Do NOT open a public GitHub issue. Open a private security advisory via the GitHub
Security tab, or email security@cletrics.com.

## Response Timeline

- Acknowledgment: within 48 hours
- Initial assessment: within 7 days
- Fix or mitigation: depends on severity

## Scope

This repository contains Markdown-based agent definitions and shell scripts for
installation and format conversion.

### Agent files (.md)
- Non-executable prompt definitions
- No API keys, secrets, or credentials should ever be committed
- Must not instruct any coding agent to execute destructive commands, exfiltrate
  data, or bypass user-configured safeguards

### Shell scripts (scripts/)
- `install.sh`, `convert.sh`, and `lint-agents.sh` are executable
- Scripts only perform local file copies into standard per-tool config
  directories. No network calls, no privilege escalation.
- Contributors should review scripts for unintended behavior before merging

## Best Practices for Contributors

- Never commit API keys, tokens, credentials, or customer cost data
- Never embed executable shell commands inside agent Markdown files in a way
  that encourages a coding agent to run them without review
- Report suspicious agent definitions that attempt prompt injection, jailbreaking,
  or policy evasion
