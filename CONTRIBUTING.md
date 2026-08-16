# Contributing to Cybersecurity Superpowers

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/rohit-barui/CyberSecurity-Superpowers.git
   cd CyberSecurity-Superpowers
   ```

2. Run the setup script:
   ```bash
   bash scripts/setup.sh
   ```

## Running Tests

Execute the full test suite:
```bash
bash tests/run-skill-tests.sh
```

## Branch Naming Conventions

- `task/<name>` — New feature or task (e.g., `task/add-java-checklists`)
- `fix/<name>` — Bug fixes (e.g., `fix/sarif-output-encoding`)
- `docs/<name>` — Documentation changes (e.g., `docs/update-readme`)

## Pull Request Guidelines

- **One feature per PR** — keep changes focused and reviewable.
- Include test results in the PR description.
- Update `CHANGELOG.md` with the changes under the appropriate section.
- All CI checks must pass before merging.

## Code Style

- **Shell scripts**: Must use `set -euo pipefail` at the top of every script.
- **Markdown files**: Use a linter (e.g., `markdownlint`) to ensure consistent formatting.
- **YAML/JSON**: Use 2-space indentation.
- Follow existing patterns in the codebase.

## Security

- Custom pre-commit hooks in `hooks/pre-commit/` scan for secrets, audit dependencies, and run static analysis automatically.
- Custom pre-push hooks in `hooks/pre-push/` validate threat models and check compliance.
- Never commit secrets, API keys, or credentials to the repository.
- Install hooks via `bash scripts/init-project.sh`.
- Report vulnerabilities per our [SECURITY.md](SECURITY.md) policy.