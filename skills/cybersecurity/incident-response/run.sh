#!/usr/bin/env bash
set -euo pipefail

# === Configuration ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="${SCRIPT_DIR}/templates"
REFERENCES_DIR="${SCRIPT_DIR}/references"
DATE="$(date +%Y-%m-%d)"

# === Argument Parsing ===
INCIDENT_TYPE=""
OUTPUT_DIR=""
DRY_RUN=false

usage() {
    echo "Usage: $0 --incident-type <type> [--output-dir <path>] [--dry-run]"
    echo ""
    echo "Options:"
    echo "  --incident-type <type>  Incident type (ransomware, data-breach, phishing, ddos, insider-threat)"
    echo "  --output-dir <path>     Output directory (default: artifacts/reports/)"
    echo "  --dry-run               Print playbook metadata as JSON to stdout only"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --incident-type)
            INCIDENT_TYPE="$2"
            shift 2
            ;;
        --output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            usage
            ;;
    esac
done

if [[ -z "${INCIDENT_TYPE}" ]]; then
    echo "ERROR: --incident-type is required" >&2
    usage
fi

# Validate incident type
VALID_TYPES=("ransomware" "data-breach" "phishing" "ddos" "insider-threat")
VALID=0
for t in "${VALID_TYPES[@]}"; do
    if [[ "${INCIDENT_TYPE}" == "${t}" ]]; then
        VALID=1
        break
    fi
done
if [[ ${VALID} -eq 0 ]]; then
    echo "ERROR: Invalid incident type '${INCIDENT_TYPE}'. Valid types: ${VALID_TYPES[*]}" >&2
    exit 1
fi

# Default output dir
if [[ -z "${OUTPUT_DIR}" ]]; then
    OUTPUT_DIR="artifacts/reports"
fi

# === Incident Procedures per Type ===
get_procedures() {
    local type="$1"
    case "${type}" in
        ransomware)
            cat <<'PROCEDURES'
### 1. Preparation
- [ ] Deploy EDR/XDR agents on all endpoints
- [ ] Maintain offline, immutable backups (3-2-1 rule)
- [ ] Implement application allowlisting / execution prevention
- [ ] Conduct tabletop exercises for ransomware scenarios
- [ ] Prepare decryption tools and offline recovery media
- [ ] Establish communication chain with law enforcement (CISA, FBI)

### 2. Detection & Analysis
- [ ] Identify ransomware strain via ransom note, file extension, or IOCs
- [ ] Scope encryption: file shares, databases, endpoints, backups
- [ ] Determine initial access vector (phishing, RDP, VPN, supply chain)
- [ ] Check for data exfiltration prior to encryption
- [ ] Preserve ransom note and any communication from attackers
- [ ] Collect memory dumps, logs, and disk images from affected systems
- [ ] Engage CISA / FBI / relevant government agency

### 3. Containment
- [ ] Isolate affected systems from the network immediately (disable NICs)
- [ ] Disable Active Directory trust relationships to affected systems
- [ ] Block known C2 infrastructure at firewall/proxy
- [ ] Change all domain admin and service account credentials
- [ ] Reset KRBTGT password twice (if AD compromised)
- [ ] Disable VPN and remote access until integrity is confirmed
- [ ] Preserve forensic images before cleanup

### 4. Eradication
- [ ] Wipe and reimage all compromised systems
- [ ] Restore from verified clean, offline backups
- [ ] Patch the initial access vector (e.g., unpatched VPN, phishing gap)
- [ ] Remove persistence mechanisms (scheduled tasks, services, registry)
- [ ] Deploy updated endpoint detection rules for identified strain
- [ ] Conduct vulnerability scan of restored environment

### 5. Recovery
- [ ] Restore data from clean backups in a staged manner
- [ ] Validate data integrity and application functionality
- [ ] Monitor restored systems for 72+ hours for recurrence
- [ ] Re-enable remote access with MFA enforcement
- [ ] Gradually restore network connectivity and services
- [ ] Verify backup integrity and restore capability

### 6. Post-Incident Activity
- [ ] Conduct root cause analysis and document timeline
- [ ] Assess if ransom was paid (policy decision, document thoroughly)
- [ ] Strengthen backup procedures and offline storage
- [ ] Update threat catalog with ransomware IOCs and TTPs
- [ ] Implement additional controls based on findings
- [ ] Share anonymized IOCs with ISAC / information-sharing partners
PROCEDURES
            ;;
        data-breach)
            cat <<'PROCEDURES'
### 1. Preparation
- [ ] Maintain data classification and inventory maps
- [ ] Implement DLP controls for sensitive data
- [ ] Establish breach notification procedures (regulatory, customer)
- [ ] Prepare legal hold and preservation notices
- [ ] Engage external breach counsel and forensic firm
- [ ] Have data breach notification templates ready

### 2. Detection & Analysis
- [ ] Confirm breach via log analysis, DLP alert, or external notification
- [ ] Identify compromised data types (PII, PHI, PCI, IP)
- [ ] Determine number of affected records and data subjects
- [ ] Identify access methods and attacker techniques
- [ ] Pinpoint when the breach occurred (dwell time analysis)
- [ ] Engage digital forensics team for full investigation
- [ ] Notify legal counsel and data protection officer

### 3. Containment
- [ ] Revoke compromised credentials and sessions
- [ ] Patch exploited vulnerability
- [ ] Block malicious IPs and domains
- [ ] Restrict access to affected databases / file shares
- [ ] Enable enhanced logging and monitoring on affected systems
- [ ] Implement network segmentation if not already in place
- [ ] Preserve all relevant logs, snapshots, and evidence

### 4. Eradication
- [ ] Remove unauthorized access points and backdoors
- [ ] Rotate all credentials potentially exposed
- [ ] Rebuild compromised systems from golden images
- [ ] Apply security patches across affected infrastructure
- [ ] Update IAM policies to enforce least privilege

### 5. Recovery
- [ ] Validate data integrity of affected records
- [ ] Restore services with enhanced monitoring
- [ ] Implement additional authentication controls (MFA)
- [ ] Monitor for signs of re-entry over the next 30 days
- [ ] Notify affected customers / partners as required by law

### 6. Post-Incident Activity
- [ ] Prepare breach notification filings per applicable regulations
- [ ] Conduct privacy impact assessment
- [ ] Update data retention and disposal policies
- [ ] Enhance data classification and DLP rules
- [ ] Provide security awareness training based on breach vector
- [ ] Document lessons learned and update IR plan
PROCEDURES
            ;;
        phishing)
            cat <<'PROCEDURES'
### 1. Preparation
- [ ] Deploy DMARC, DKIM, and SPF email authentication
- [ ] Implement email filtering and sandboxing
- [ ] Conduct regular phishing simulation exercises
- [ ] Establish incident response procedures for credential theft
- [ ] Provide security awareness training on phishing indicators
- [ ] Prepare account takeover response runbooks

### 2. Detection & Analysis
- [ ] Analyze phishing email headers and URLs
- [ ] Determine campaign scope (number of recipients, clickers)
- [ ] Identify credentials or data submitted via phishing page
- [ ] Check for email forwarding rules created by attackers
- [ ] Investigate mailbox access and suspicious logins
- [ ] Extract IOCs (sender, domain, IPs, attachments)
- [ ] Scan endpoints of users who clicked for malware

### 3. Containment
- [ ] Force password reset for affected users
- [ ] Revoke session tokens and API keys for compromised accounts
- [ ] Remove any unauthorized email forwarding rules
- [ ] Block phishing domain, IPs, and sender addresses
- [ ] Disable compromised accounts temporarily if lateral movement suspected
- [ ] Enable MFA enforcement for all users
- [ ] Quarantine affected mailboxes for forensic analysis

### 4. Eradication
- [ ] Remove malicious emails from all mailboxes
- [ ] Clean malware from affected endpoints
- [ ] Remove persistence from compromised accounts
- [ ] Update email filters to block identified patterns
- [ ] Review and revoke delegated access and app permissions

### 5. Recovery
- [ ] Re-enable accounts after security verification
- [ ] Monitor accounts for anomalous activity for 30 days
- [ ] Enhance email security controls
- [ ] Conduct user retraining for affected users
- [ ] Validate that none of the accounts were used for lateral movement

### 6. Post-Incident Activity
- [ ] Update email security rules and filtering baselines
- [ ] Enhance phishing detection signatures
- [ ] Review and improve user reporting mechanisms
- [ ] Share phishing IOCs with industry partners
- [ ] Update IR plan with lessons from response
- [ ] Conduct targeted retraining for users who fell for phishing
PROCEDURES
            ;;
        ddos)
            cat <<'PROCEDURES'
### 1. Preparation
- [ ] Engage with DDoS mitigation provider (Cloudflare, Akamai, AWS Shield)
- [ ] Implement rate limiting and WAF rules
- [ ] Design elastic/auto-scaling infrastructure
- [ ] Establish DDoS response runbooks for different attack vectors
- [ ] Maintain out-of-band communication channels
- [ ] Configure traffic baseline monitoring and alerting
- [ ] Prepare public status page for customer communication

### 2. Detection & Analysis
- [ ] Identify attack type (volumetric, protocol, application layer)
- [ ] Validate attack traffic vs legitimate traffic spikes
- [ ] Determine attack source IPs, ASNs, and geolocations
- [ ] Assess impact: CPU, bandwidth, latency, availability
- [ ] Analyze WAF and CDN logs for attack patterns
- [ ] Engage upstream provider / mitigation partner immediately
- [ ] Document bandwidth and pps metrics for post-incident analysis

### 3. Containment
- [ ] Enable DDoS mitigation provider scrubbing
- [ ] Implement rate limiting at load balancer and WAF
- [ ] Block source IPs, subnets, or countries at perimeter
- [ ] Enable SYN flood protection, connection limiting
- [ ] Scale up infrastructure resources to absorb traffic
- [ ] Consider GeoIP blocking for unrelated source regions
- [ ] Implement CAPTCHA or browser challenges for application attacks

### 4. Eradication
- [ ] Coordinate with ISP upstream to null-route attack IPs
- [ ] Tune WAF rules to block attack patterns
- [ ] Deploy additional auto-scaling groups
- [ ] Update ACLs and security group rules
- [ ] Implement Anycast routing if available

### 5. Recovery
- [ ] Gradually remove temporary blocking rules
- [ ] Monitor traffic patterns for attack resumption
- [ ] Validate full service availability and performance
- [ ] Confirm no residual impact on latency or throughput
- [ ] Communicate service restored to stakeholders

### 6. Post-Incident Activity
- [ ] Analyze attack vectors and patterns for future prevention
- [ ] Assess cost impact (bandwidth overage, mitigation services)
- [ ] Update DDoS response runbooks with new insights
- [ ] Evaluate need for additional scrubbing capacity
- [ ] Test disaster recovery failover capability if triggered
- [ ] Coordinate with threat intel feeds on attack infrastructure
PROCEDURES
            ;;
        insider-threat)
            cat <<'PROCEDURES'
### 1. Preparation
- [ ] Implement UBA/UEBA for anomalous user behavior detection
- [ ] Establish data exfiltration monitoring (DLP, USB controls)
- [ ] Define clear insider threat policy and reporting procedures
- [ ] Coordinate with HR and legal for investigation protocols
- [ ] Implement privileged access monitoring and PAM
- [ ] Limit data access based on least privilege principle
- [ ] Prepare employee exit procedures with access revocation

### 2. Detection & Analysis
- [ ] Identify anomalous behavior: unusual access times, large data downloads
- [ ] Analyze HR flags: pending termination, performance issues, policy violations
- [ ] Review access logs: VPN, application, database, file server
- [ ] Check for data exfiltration: email, USB, cloud uploads, printing
- [ ] Interview relevant managers and peers (discreetly)
- [ ] Determine if this is malicious or negligent insider activity
- [ ] Engage HR and legal before taking personnel action
- [ ] Preserve all logs, camera footage, and access records

### 3. Containment
- [ ] Revoke or restrict system access immediately
- [ ] Suspend user accounts and sessions
- [ ] Escort individual from premises if physical access exists
- [ ] Preserve user workstation, phone, and devices for forensics
- [ ] Disable VPN, remote access, and badge access
- [ ] Monitor for data destruction attempts
- [ ] Place litigation hold on relevant data sources

### 4. Eradication
- [ ] Recover exfiltrated data if possible (contact cloud provider, etc.)
- [ ] Remove any unauthorized accounts or backdoors created
- [ ] Change shared credentials the insider had access to
- [ ] Review and revoke delegated access and permissions
- [ ] Update access controls to prevent recurrence
- [ ] Patch any bypassed security controls

### 5. Recovery
- [ ] Restore any corrupted or deleted data from backups
- [ ] Reissue credentials and access for legitimate team members
- [ ] Implement additional monitoring on sensitive data repositories
- [ ] Validate no other accounts were compromised by the insider

### 6. Post-Incident Activity
- [ ] Work with HR for appropriate personnel action (if malicious)
- [ ] Update access management and termination procedures
- [ ] Enhance UEBA rules based on identified patterns
- [ ] Review least-privilege implementations across the organization
- [ ] Update insider threat program documentation
- [ ] Conduct exit interview process improvement
PROCEDURES
            ;;
    esac
}

# === Severity Mapping ===
get_severity() {
    local type="$1"
    case "${type}" in
        ransomware) echo "CRITICAL" ;;
        data-breach) echo "CRITICAL" ;;
        phishing) echo "HIGH" ;;
        ddos) echo "HIGH" ;;
        insider-threat) echo "CRITICAL" ;;
    esac
}

# === Templates ===
get_templates() {
    cat <<'TEMPLATES'
### Initial Internal Alert
**Subject:** [SEVERITY] Security Incident - {{INCIDENT_TYPE}} Detected
**Time Detected:** {{DATE}} [Timestamp]
**Affected Systems:** [TBD]
**Current Status:** Investigation
**Point of Contact:** Incident Manager

### Customer Notification (if applicable)
**Subject:** Security Notice - {{DATE}}
We are writing to inform you of a security incident that may affect your data.
**What happened:** [Description]
**What we are doing:** [Actions]
**What you should do:** [Customer actions if any]

### Regulatory Notification (if applicable)
**To:** [Regulatory Authority]
**Date of Incident:** {{DATE}}
**Type:** {{INCIDENT_TYPE}}
**Measures Taken:** [Actions]
**Contact:** [DPO / Incident Manager]

### Resolution Notice
**Subject:** Incident Resolved - {{INCIDENT_TYPE}}
**Root cause:** [Description]
**Actions taken:** [List]
**Future prevention:** [Steps]
TEMPLATES
}

# === Collect Phase Content with Placeholders ===
PHASES_CONTENT="$(get_procedures "${INCIDENT_TYPE}")"
SEVERITY="$(get_severity "${INCIDENT_TYPE}")"

# === Role Definitions with RACI ===
ROLES_TABLE=$(cat <<'RACI'
| Role | Responsibility | R | A | C | I |
|------|--------------|---|---|---|---|
| **Incident Manager** | Oversees entire IR process, coordinates resources | ✓ | | | |
| **Technical Lead** | Leads investigation, containment, eradication | | ✓ | | |
| **Communications Lead** | Manages all internal/external communications | | | ✓ | |
| **Legal Counsel** | Advises on legal obligations, notifications | | | | ✓ |
| **Forensics Analyst** | Collects and analyzes evidence | | | ✓ | |
| **HR Representative** | Handles personnel aspects (insider threats) | | | | ✓ |
| **PR / Media** | Public statements and media inquiries | | | | ✓ |
| **CISO / Executive** | Approves public communications, escalation | | ✓ | | |
RACI
)

# === Evidence Collection Guidelines ===
EVIDENCE_TABLE=$(cat <<'EVIDENCE'
| Evidence Type | Source | Collection Method |
|---------------|--------|-------------------|
| System logs | SIEM, syslog, Event Viewer | Forensic copy with hashing |
| Network captures | pcap, netflow | tcpdump / Wireshark |
| Memory dumps | RAM | FTK Imager, LiME, WinPmem |
| Disk images | Hard drives, SSDs | dd, FTK Imager, Guymager |
| Email headers | Mail server | Export .EML, preserve headers |
| Application logs | Web/app servers | Collector agent, manual export |
| Cloud logs | AWS CloudTrail, Azure Monitor | API export, immutable storage |
EVIDENCE
)

# === Severity Matrix ===
SEVERITY_MATRIX=$(cat <<'SMATRIX'
| Severity | Definition | Response SLA | Examples |
|----------|-----------|-------------|----------|
| **CRITICAL** | Active compromise, data exfiltration, encryption | < 15 min notification | Ransomware, APT breach |
| **HIGH** | Non-critical compromise, high exploitation likelihood | < 1 hour | Unauthorized admin, credential theft |
| **MEDIUM** | Suspected compromise, moderate impact | < 4 hours | Policy violation, single workstation |
| **LOW** | Minimal impact, no sensitive data | < 24 hours | Port scan, minor policy violation |
SMATRIX
)

# === Build Playbook Content ===
COMMUNICATION_TEMPLATES="$(get_templates)"
COMMUNICATION_TEMPLATES="${COMMUNICATION_TEMPLATES//{{INCIDENT_TYPE}}/${INCIDENT_TYPE}}"
COMMUNICATION_TEMPLATES="${COMMUNICATION_TEMPLATES//{{DATE}}/${DATE}}"
PHASES_CONTENT="${PHASES_CONTENT//{{SEVERITY}}/${SEVERITY}}"

PLAYBOOK=$(cat <<PLAYBOOK
# Incident Response Playbook

## Incident Type: ${INCIDENT_TYPE}
## Severity: ${SEVERITY}
## Date Generated: ${DATE}

---

## Role Definitions with RACI

${ROLES_TABLE}

## Severity Classification Matrix

${SEVERITY_MATRIX}

## Evidence Collection Guidelines

${EVIDENCE_TABLE}

---

## Phases

${PHASES_CONTENT}

---

## Communication Templates

${COMMUNICATION_TEMPLATES}

---

## References

- NIST SP 800-61 Rev. 2 (Computer Security Incident Handling Guide)
- NIST SP 800-86 (Guide to Integrating Forensic Techniques into Incident Response)
- SANS Incident Response Process
- ISO/IEC 27035 (Information security incident management)
- CISA Cyber Incident Response Plan Template
PLAYBOOK
)

# === Dry Run or Write ===
if [[ "${DRY_RUN}" == true ]]; then
    cat <<JSON
{
  "playbook": "incident-playbook.md",
  "incident_type": "${INCIDENT_TYPE}",
  "severity": "${SEVERITY}",
  "date_generated": "${DATE}",
  "phases": [
    "Preparation",
    "Detection & Analysis",
    "Containment",
    "Eradication",
    "Recovery",
    "Post-Incident Activity"
  ],
  "output_dir": "${OUTPUT_DIR}",
  "nist_alignment": "SP 800-61 Rev. 2",
  "evidence_collection": true,
  "communication_templates": true,
  "raci_matrix": true,
  "severity_matrix": true
}
JSON
    exit 0
fi

# Ensure output directory exists
mkdir -p "${OUTPUT_DIR}"

# Write playbook
OUTPUT_FILE="${OUTPUT_DIR}/incident-playbook.md"
echo "${PLAYBOOK}" > "${OUTPUT_FILE}"

echo "SUCCESS: Incident response playbook written to ${OUTPUT_FILE}" >&2
exit 0