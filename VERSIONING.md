# Versioning

This project uses [Semantic Versioning](https://semver.org/).

## Scheme

**v0.x.y** — pre-release (breaking changes allowed)

| Bump | When |
|------|------|
| **Major (x)** | Breaking changes to skill API, directory structure, or agent wiring |
| **Minor (y)** | New skills, new frameworks, new CI/CD workflows, new hooks |
| **Patch** | Bug fixes, template improvements, docs, tool config updates |

## Release Process

1. Work happens on `develop` branch
2. When ready: `git checkout main && git merge develop --no-ff`
3. Tag: `git tag -a v0.x.y -m "v0.x.y - <summary>"`
4. Push: `git push origin main --tags`
5. Write changelog entry in release notes on GitHub

## Changelog

Each release tag on GitHub serves as the changelog. Use conventional commit format so release notes can be auto-generated:

```
feat: new skill or feature
fix: bug or template fix
docs: documentation changes
chore: tooling, configs, CI/CD
```

## Branches

| Branch | Purpose | Lifecycle |
|--------|---------|-----------|
| `main` | Stable release | Tagged versions only |
| `develop` | Active work | Default target for PRs |
