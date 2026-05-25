---
name: incident-response
description: "Generates a NIST-aligned incident-response playbook with checklists, communication templates, and lessons-learned documentation."
---

# Incident Response Skill

This skill helps you create an incident response playbook aligned with NIST SP 800-61 (Computer Security Incident Handling Guide). It provides checklists, communication templates, and lessons-learned documentation to handle security incidents effectively.

## When to Use

You MUST use this skill when a security vulnerability is confirmed or suspected, or after a penetration test reveals exploitable issues, to prepare a structured response.

## Process Flow

1. **Identify the incident type** based on:
   - The vulnerability or breach discovered (e.g., data leak, unauthorized access, malware, etc.)
   - The affected assets and data.
   - The severity (using CVSS or similar).

2. **Follow the NIST SP 800-61 lifecycle**:
   - **Preparation**: Ensure policies, tools, and training are in place.
   - **Detection and Analysis**: Identify and analyze signs of an incident.
   - **Containment, Eradication, and Recovery**: Limit damage, remove threats, and restore systems.
   - **Post-Incident Activity**: Learn from the incident and improve defenses.

3. **Create an incident response playbook** that includes:
   - **Roles and responsibilities**: Define who does what (incident manager, technical lead, communications, legal, etc.).
   - **Communication plan**: Templates for internal and external communication (including regulators and customers).
   - **Procedures**: Step-by-step guides for each phase of the lifecycle.
   - **Evidence collection**: Guidelines for preserving evidence for potential legal action.
   - **Lessons learned**: Process for reviewing the incident and updating defenses.

4. **Document the playbook** in a file named `INCIDENT_RESPONSE_PLAYBOOK.md` in the project root (or update if exists) that includes:
   - Introduction and scope
   - Definitions of incident types and severity levels
   - Roles and responsibilities
   - Communication templates (e.g., initial alert, status update, resolution notice)
   - Detailed procedures for each phase (with checklists)
   - Evidence collection guidelines
   - Post-incident review process
   - References to relevant policies and laws

## Output

- `INCIDENT_RESPONSE_PLAYBOOK.md`: A comprehensive guide for responding to security incidents in the project.

## Examples

See `skills/cybersecurity/incident-response/examples/` for sample playbook sections.

## References

- NIST SP 800-61 Rev. 2 (Computer Security Incident Handling Guide)
- NIST SP 800-86 (Guide to Integrating Forensic Techniques into Incident Response)
- SANS Incident Response Process
- ISO/IEC 27035 (Information security incident management)
- CISA Cyber Incident Response Plan Template