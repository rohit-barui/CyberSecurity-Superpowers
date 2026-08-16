# Software Bill of Materials (SBOM)

## Project: {{PROJECT_NAME}}
## Generated: {{DATE}}
## Format: {{FORMAT}}

---

## SBOM Metadata

| Field | Value |
|-------|-------|
| Project | {{PROJECT_NAME}} |
| Generated | {{DATE}} |
| Format | {{FORMAT}} |
| Spec Version | CycloneDX 1.4 / SPDX 2.3 |
| Tool | Supply-Chain Security Skill (Cybersecurity Superpowers) |
| Total Dependencies | {{TOTAL_DEPENDENCIES}} |

---

## Summary

| Total Dependencies | Direct | Transitive | Vulnerabilities (HIGH+) |
|-------------------|--------|------------|------------------------|
| {{TOTAL_DEPENDENCIES}} | {{DIRECT_DEPENDENCIES}} | {{TRANSITIVE_DEPENDENCIES}} | {{HIGH_VULNERABILITIES}} |

---

## Dependency List

{{DEPENDENCIES_TABLE}}

---

## Dependency Tree

{{DEPENDENCY_TREE}}

---

## Vulnerability Details

{{VULNERABILITIES_TABLE}}

---

## License Compliance

| Package | Version | License | Status |
|---------|---------|---------|--------|
{{LICENSE_TABLE}}

---

## Recommendations

{{RECOMMENDATIONS}}

---

## References

- [CycloneDX v1.4](https://cyclonedx.org/specification/overview/)
- [SPDX v2.3](https://spdx.github.io/spdx-spec/)
- [NVD (National Vulnerability Database)](https://nvd.nist.gov/)
- [OSV.dev](https://osv.dev/)
- [GitHub Advisory Database](https://github.com/advisories)