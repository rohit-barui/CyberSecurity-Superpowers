# C4 Component Diagram — Skill Internals

## Threat-Modeling Skill Internals

The threat-modeling skill is composed of four internal components that process user input through a structured pipeline.

### Components

| Component | Description |
|-----------|-------------|
| **CLI Parser** | Parses arguments (`--project`, `--output-dir`, `--dry-run`, `--format`) and validates input |
| **Template Engine** | Loads STRIDE template from `templates/stride-model.md`, substitutes `{{PROJECT_NAME}}`, `{{DATE}}`, `{{CVSS_MATRIX}}`, `{{STRIDE_TABLE}}` tokens |
| **CVSS Generator** | Populates a CVSS v3.1 score matrix table with threat-specific metrics (AV, AC, PR, UI, S, C, I, A) |
| **Report Generator** | Assembles findings into markdown or JSON output |

### Component Diagram

```mermaid
C4Component
  title Component diagram for Threat-Modeling Skill

  Container_Boundary(tm, "Threat-Modeling Skill") {
    Component(cli, "CLI Parser", "Bash", "Parses --project, --output-dir, --dry-run, --format")
    Component(template, "Template Engine", "Bash + sed", "Loads stride-model.md, substitutes tokens")
    Component(cvss, "CVSS Generator", "Bash", "Generates CVSS v3.1 scoring matrix")
    Component(report, "Report Generator", "Bash", "Outputs stride-model.md or stride-model.json")
  }

  Rel(cli, template, "Passes project name, format")
  Rel(template, cvss, "Requests CVSS matrix")
  Rel(template, report, "Sends populated report")
```

## Secure-Coding Skill Internals

### Components

| Component | Description |
|-----------|-------------|
| **CLI Parser** | Parses arguments (`--language`, `--target-dir`, `--output-dir`, `--dry-run`) and validates input |
| **Language Detector** | Auto-detects language from file extensions (`.js`, `.ts`, `.py`, `.go`, `.rs`) when `--language` is not specified |
| **Checklist Loader** | Loads the appropriate OWASP-based checklist from `checklists/<lang>.md` |
| **Report Generator** | Assembles checklist items and violations into `SECURITY.md` using template substitution |

### Component Diagram

```mermaid
C4Component
  title Component diagram for Secure-Coding Skill

  Container_Boundary(sc, "Secure-Coding Skill") {
    Component(cli2, "CLI Parser", "Bash", "Parses --language, --target-dir, --output-dir, --dry-run")
    Component(detector, "Language Detector", "Bash", "Auto-detects language from file extensions")
    Component(loader, "Checklist Loader", "Bash", "Loads checklists/<lang>.md")
    Component(report2, "Report Generator", "Bash", "Outputs SECURITY.md")
  }

  Rel(cli2, detector, "Requests language detection")
  Rel(cli2, loader, "Instructs which checklist to load")
  Rel(loader, report2, "Sends checklist items")
  Rel(detector, loader, "Provides detected language")
```