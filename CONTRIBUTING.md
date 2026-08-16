# Contributing to Cybersecurity Superpowers

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/rohit-barui/cybersecurity-superpowers.git
   cd cybersecurity-superpowers
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

Run tests for a specific skill:
```bash
bash tests/run-skill-tests.sh --skill <skill-name>
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
- Squash commits before merging.

## Code Style

- **Shell scripts**: Must use `set -euo pipefail` at the top of every script.
- **Markdown files**: Use a linter (e.g., `markdownlint`) to ensure consistent formatting.
- **YAML/JSON**: Use 2-space indentation.
- Follow existing patterns in the codebase.

## Security

- Pre-commit hooks are configured to check for secrets, large files, and code quality.
- Never commit secrets, API keys, or credentials to the repository.
- Run `pre-commit run --all-files` before pushing.
- Report vulnerabilities per our [SECURITY.md](SECURITY.md) policy.