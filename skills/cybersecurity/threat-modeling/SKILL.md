---
name: threat-modeling
description: "Generates a STRIDE-based threat model, assigns CVSS scores, and recommends mitigations (OWASP, NIST)."
---

# Threat Modeling Skill

This skill helps you create a threat model for your project using the STRIDE methodology, assign CVSS scores to identified threats, and recommend mitigations based on OWASP and NIST guidelines.

## When to Use

You MUST use this skill during the design phase, after brainstorming and before writing implementation plans, to ensure security is considered early in the development lifecycle.

## Process Flow

1. **Review the project context** (architecture, data flows, trust boundaries)
2. **Identify assets** and their sensitivity
3. **Apply STRIDE categories** to each asset/entry point:
   - Spoofing
   - Tampering
   - Repudiation
   - Information Disclosure
   - Denial of Service
   - Elevation of Privilege
4. **Assign CVSS scores** (using CVSS v3.1) to each threat based on:
   - Attack Vector
   - Attack Complexity
   - Privileges Required
   - User Interaction
   - Scope
   - Confidentiality Impact
   - Integrity Impact
   - Availability Impact
5. **Recommend mitigations** using:
   - OWASP ASVS
   - NIST SP 800-53
   - Language-specific secure coding practices
6. **Run the tool**: `./skills/cybersecurity/threat-modeling/run.sh --project <name> --output-dir artifacts/reports`
 7. **Document findings** in `artifacts/reports/stride-model.md`
 8. **Update security backlog** with prioritized tasks

## Output

- `artifacts/reports/stride-model.md`: Contains the threat model, CVSS scores, and mitigation recommendations
- Updated `SECURITY.md` (if exists) with new security requirements

## Examples

See `artifacts/reports/example-stride-model.md` for a sample threat model.

## References

- OWASP Threat Modeling Project
- NIST SP 800-30 Rev. 1 (Guide for Conducting Risk Assessments)
- CVSS v3.1 Specification
- MITRE ATT&CK Framework