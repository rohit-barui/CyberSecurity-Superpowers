# Supply-Chain Security Skill

## Purpose

Generate Software Bill of Materials (SBOM) in SPDX and CycloneDX formats, perform dependency vulnerability scanning, and detect supply-chain attacks.

Capabilities:
- **SBOM Generation**: Produce SPDX 2.3 and CycloneDX 1.4 compliant SBOMs
- **Dependency Scanning**: Cross-reference dependencies against known vulnerability databases (NVD, OSV, GitHub Advisory)
- **Supply-Chain Detection**: Identify typosquatting, compromised packages, and dependency confusion attacks
- **License Compliance**: Verify dependency licenses against policy
- **Remediation Guidance**: Suggest version bumps, patches, or alternative packages

## Process Flow

```
[Manifest Detection] -> [SBOM Generation] -> [Vulnerability Cross-Reference] -> [Remediation]
       |                       |                         |                          |
  package.json,          trivy / cyclonedx-bom      NVD / OSV / GHSA         patch / replace
  requirements.txt,      / fallback parser           database lookup          / accept risk
  go.mod, Cargo.toml,
  pom.xml
```

1. **Manifest Detection**: Scan `--target-dir` for known manifest files
2. **SBOM Generation**: Run trivy / cyclonedx-bom / fallback parser
3. **Vulnerability Cross-Reference**: Match dependencies against CVE database
4. **Reporting**: Write JSON and Markdown reports to output directory
5. **Remediation**: Produce prioritized fix list

## Inputs

| Input | Source | Description |
|-------|--------|-------------|
| Source code | `--target-dir` | Project to analyze |
| Tool configuration | `scripts/generate-sbom.sh` | Scan settings |

## Outputs

| Output | Path | Format |
|--------|------|--------|
| SBOM Report (JSON) | `artifacts/sbom/sbom-report.json` | CycloneDX / SPDX JSON |
| SBOM Report (Markdown) | `artifacts/sbom/sbom-report.md` | Markdown |

## Dependencies

- **Runtime**: bash, trivy (optional), npx (optional), node (optional)
- **CI/CD**: Any runner with shell access

## References

- [CycloneDX Specification v1.4](https://cyclonedx.org/specification/overview/)
- [SPDX Specification v2.3](https://spdx.github.io/spdx-spec/)
- [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/)
- [NIST SP 800-161 (Supply Chain Risk Management)](https://csrc.nist.gov/publications/detail/sp/800-161/rev-1/final)
- [OpenSSF Scorecard](https://securityscorecards.dev/)
- [SLSA Framework](https://slsa.dev/)