# STRIDE Threat Model

## Project: Audit App
## Date: 2026-08-16T12:00:00Z

## CVSS Scoring Matrix

The following CVSS v3.1 vector strings and scores are used throughout this document:

| Metric | Value | Score |
|--------|-------|-------|
| Attack Vector (AV) | Network | 0.85 |
| Attack Complexity (AC) | Low | 0.77 |
| Privileges Required (PR) | None / Low | 0.85 / 0.62 |
| User Interaction (UI) | None | 0.85 |
| Scope (S) | Unchanged | 0.00 |
| Confidentiality (C) | High / None | 0.56 / 0.00 |
| Integrity (I) | High / None | 0.56 / 0.00 |
| Availability (A) | High / None | 0.56 / 0.00 |
| **Base Score Range** | | **4.3 - 9.1** |

## STRIDE Threat Categorization

| Category | Threat Description | Asset Affected | Impact | Likelihood | Risk Score | CVSS Vector | CVSS Score | Mitigation |
|----------|-------------------|----------------|--------|------------|------------|-------------|------------|------------|
| Spoofing | An attacker impersonates an auditor by forging JWT tokens or replaying session cookies | Authentication service, JWT signing keys, auditor dashboards | High | Medium | 7.5 | CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N | 9.1 | Enforce short-lived JWT tokens with RS256 signatures; implement token binding via mTLS; deploy reCAPTCHA on login forms |
| Tampering | Attacker modifies audit log entries to cover fraudulent activity | Audit log database (PostgreSQL), log shipping pipeline, S3 log archive | High | Medium | 7.0 | CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:H/A:N | 6.5 | Write-once-read-many (WORM) storage for audit logs; enable PostgreSQL audit triggers; sign each log entry with HMAC-SHA256; use immutable S3 Object Lock |
| Repudiation | A compliance officer denies having approved a suspicious transaction | Approval workflow records, blockchain-based audit trail, compliance dashboard | Medium | Low | 4.5 | CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:N | 4.3 | Capture digital signatures for all approvals; emit approval events to an immutable event log; integrate with Splunk for SIEM correlation |
| Information Disclosure | Audit data containing PII is exposed via misconfigured S3 bucket or verbose API error messages | S3 audit bucket, API Gateway responses, CloudWatch logs, PII fields | High | Medium | 7.5 | CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N | 7.5 | Enable S3 bucket policies with public access blocking; mask PII fields in API responses (e.g., "SSN: XXX-XX-1234"); use AWS KMS for envelope encryption |
| Denial of Service | Attacker floods the audit ingestion API with garbage events, preventing legitimate audit submissions | Audit ingestion API (API Gateway + Lambda), DynamoDB write capacity, CloudWatch metrics | High | Medium | 6.5 | CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H | 7.5 | Configure API Gateway usage plans and rate limits; enable DynamoDB auto-scaling; deploy AWS WAF with rate-based rules; implement client-side backpressure |
| Elevation of Privilege | A read-only auditor escalates to admin by exploiting a broken access control in the GraphQL layer | GraphQL API, Role resolver, Admin mutation endpoints | Critical | Low | 8.0 | CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H | 8.8 | Enforce RBAC at the API gateway layer (not just in-app); validate permissions on every resolver; run automated access control tests in CI/CD; use AWS IAM Conditions for cross-account access |

## Trust Boundaries

- **Internet → AWS CloudFront**: TLS 1.3 termination, WAF rules, DDoS protection via AWS Shield
- **CloudFront → API Gateway**: VPC origins only; signed URLs for private distributions
- **API Gateway → Lambda**: IAM-based invocation permissions; request validation at the gateway
- **Lambda → DynamoDB / RDS**: VPC endpoints; least-privilege IAM roles; encrypted at rest
- **RDS → S3 Audit Archive**: Cross-account IAM roles; KMS encryption; S3 bucket policy enforcement

## Assumptions

1. All inter-service communication occurs within a VPC or over mTLS
2. Audit logs are immutable after finalization (no deletion or modification)
3. JWT signing keys are rotated every 90 days and stored in AWS KMS
4. Compliance officers have completed annual security awareness training
5. The system is deployed in us-east-1 with cross-region DR in us-west-2

## CVSS Score Reference

| Severity | Score Range |
|----------|-------------|
| None | 0.0 |
| Low | 0.1 - 3.9 |
| Medium | 4.0 - 6.9 |
| High | 7.0 - 8.9 |
| Critical | 9.0 - 10.0 |

## Threat Details

### CVSS v3.1 Score Details

| Threat | AV | AC | PR | UI | S | C | I | A | Score | Severity |
|--------|----|----|----|----|----|----|----|----|-------|----------|
| Spoofing | N | L | N | N | U | H | H | N | 9.1 | Critical |
| Tampering | N | L | L | N | U | N | H | N | 6.5 | Medium |
| Repudiation | N | L | L | N | U | N | L | N | 4.3 | Medium |
| Information Disclosure | N | L | N | N | U | H | N | N | 7.5 | High |
| Denial of Service | N | L | N | N | U | N | N | H | 7.5 | High |
| Elevation of Privilege | N | L | L | N | U | H | H | H | 8.8 | High |

### Prioritized Action Items

1. **CRITICAL**: Implement MFA and mTLS for all auditor logins (Spoofing — CVSS 9.1)
2. **HIGH**: Enforce WORM policy on S3 audit log bucket (Tampering — CVSS 6.5)
3. **HIGH**: Mask PII fields in API responses and enable KMS encryption on S3 (Info Disclosure — CVSS 7.5)
4. **HIGH**: Configure rate limiting and WAF on the ingestion API (DoS — CVSS 7.5)
5. **HIGH**: Implement API-gateway-level RBAC with automated permission tests (EoP — CVSS 8.8)
6. **MEDIUM**: Integrate digital signatures into approval workflows (Repudiation — CVSS 4.3)

### OWASP ASVS Controls Applied

- **V2 (Authentication)**: MFA enforced, credential rotation, account lockout after 5 failed attempts
- **V3 (Session Management)**: JWT with RS256, 15-minute expiry, secure cookie flags
- **V4 (Access Control)**: RBAC at API Gateway, deny-by-default, per-resource IAM conditions
- **V7 (Logging)**: Immutable audit logs, log injection prevention, centralized SIEM
- **V11 (Cryptography)**: AES-256-GCM for data at rest, TLS 1.3 for data in transit, KMS key rotation

### NIST SP 800-53 Controls Referenced

- **AC-2**: Account Management — automated provisioning/deprovisioning via SCIM
- **AC-6**: Least Privilege — IAM roles scoped to least privilege for each Lambda function
- **AU-2**: Audit Events — all security-relevant events logged to CloudTrail + CloudWatch Logs
- **AU-9**: Protection of Audit Information — S3 Object Lock in compliance mode (retention: 7 years)
- **SC-8**: Transmission Confidentiality and Integrity — TLS 1.3 enforced at all network boundaries
- **SC-12**: Cryptographic Key Establishment and Management — AWS KMS with automatic rotation
- **SC-28**: Protection at Rest — DynamoDB, RDS, and S3 encryption enabled with KMS CMK
- **SI-4**: System Monitoring — CloudWatch alarms + GuardDuty + Security Hub integration

---

*Generated by Cybersecurity Superpowers Threat-Modeling Skill*
*Template: skills/cybersecurity/threat-modeling/templates/stride-model.md*