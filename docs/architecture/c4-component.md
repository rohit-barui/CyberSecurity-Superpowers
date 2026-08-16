# C4 Component Diagram — Skill Internals

## Threat-Modeling Skill Internals

The threat-modeling skill is composed of four internal components that process user input through a structured pipeline.

### Components

| Component | Description |
|-----------|-------------|
| **CLI Parser** | Parses arguments (language, threat model type, project path) and validates input |
| **Template Engine** | Loads STRIDE or LINDDUN templates from `templates/`, populates with project context |
| **CVSS Calculator** | Computes CVSS 3.1 scores for identified threats based on user-provided impact metrics |
| **Report Generator** | Assembles findings into markdown or SARIF output |

```mermaid
C4Component
  title Component diagram for Threat-Modeling Skill

  Container_Boundary(skill, "Threat-Model Skill") {
    Component(cli, "CLI Parser", "Bash", "Parses arguments: language, model type, project path")
    Component(tmpl, "Template Engine", "Bash", "Loads STRIDE/LINDDUN templates, populates context")
    Component(cvss, "CVSS Calculator", "Bash", "Computes CVSS 3.1 scores")
    Component(report, "Report Generator", "Bash", "Assembles findings into markdown/SARIF")

    Rel(cli, tmpl, "Passes parsed options", "")
    Rel(tmpl, cvss, "Sends threat data for scoring", "")
    Rel(cvss, report, "Sends scored threats", "")
    Rel(cli, report, "Passes output format preference", "")
  }

  System_Ext(fs, "File System", "templates/, references/")
  System_Ext(user, "User / Orchestrator", "Invocation")

  Rel(user, cli, "Arguments", "CLI")
  Rel(tmpl, fs, "Reads", "file I/O")
  Rel(report, fs, "Writes output", "file I/O")
```

## Secure-Coding Skill Internals

The secure-coding skill applies language-specific secure coding checklists to a project.

### Components

| Component | Description |
|-----------|-------------|
| **CLI Parser** | Parses project path, language, and severity threshold arguments |
| **Checklist Loader** | Loads the appropriate OWASP-based checklist for the detected language |
| **Language Detector** | Auto-detects programming languages from project file extensions |
| **Report Generator** | Produces a findings report with pass/fail status per checklist item |

```mermaid
C4Component
  title Component diagram for Secure-Coding Skill

  Container_Boundary(skill, "Secure-Coding Skill") {
    Component(cli, "CLI Parser", "Bash", "Parses project path, language, severity threshold")
    Component(ckld, "Checklist Loader", "Bash", "Loads OWASP-based checklist for detected language")
    Component(lang, "Language Detector", "Bash", "Auto-detects languages from project files")
    Component(report, "Report Generator", "Bash", "Produces pass/fail findings report")

    Rel(cli, lang, "Instructs detection", "")
    Rel(cli, ckld, "Passes language", "")
    Rel(lang, ckld, "Provides detected language", "")
    Rel(ckld, report, "Sends checklist results", "")
    Rel(cli, report, "Passes output format", "")
  }

  System_Ext(fs, "File System", "checklists/, templates/, references/")
  System_Ext(user, "User / Orchestrator", "Invocation")

  Rel(user, cli, "Arguments", "CLI")
  Rel(ckld, fs, "Reads", "file I/O")
  Rel(lang, fs, "Scans", "file I/O")
  Rel(report, fs, "Writes output", "file I/O")
```