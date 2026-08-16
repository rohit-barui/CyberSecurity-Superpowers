# Incident Response Playbook

## Incident Type: ransomware
## Severity: CRITICAL
## Date Generated: 2026-08-16

---

## Role Definitions with RACI

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

## Severity Classification Matrix

| Severity | Definition | Response SLA | Examples |
|----------|-----------|-------------|----------|
| **CRITICAL** | Active compromise, data exfiltration, encryption | < 15 min notification | Ransomware, APT breach |
| **HIGH** | Non-critical compromise, high exploitation likelihood | < 1 hour | Unauthorized admin, credential theft |
| **MEDIUM** | Suspected compromise, moderate impact | < 4 hours | Policy violation, single workstation |
| **LOW** | Minimal impact, no sensitive data | < 24 hours | Port scan, minor policy violation |

## Evidence Collection Guidelines

| Evidence Type | Source | Collection Method |
|---------------|--------|-------------------|
| System logs | SIEM, syslog, Event Viewer | Forensic copy with hashing |
| Network captures | pcap, netflow | tcpdump / Wireshark |
| Memory dumps | RAM | FTK Imager, LiME, WinPmem |
| Disk images | Hard drives, SSDs | dd, FTK Imager, Guymager |
| Email headers | Mail server | Export .EML, preserve headers |
| Application logs | Web/app servers | Collector agent, manual export |
| Cloud logs | AWS CloudTrail, Azure Monitor | API export, immutable storage |

---

## Phases

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

---

## Communication Templates

### Initial Internal Alert
**Subject:** CRITICAL Security Incident - ransomware Detected
**Time Detected:** 2026-08-16 [Timestamp]
**Affected Systems:** [TBD]
**Current Status:** Investigation
**Point of Contact:** Incident Manager

### Customer Notification (if applicable)
**Subject:** Security Notice - 2026-08-16
We are writing to inform you of a security incident that may affect your data.
**What happened:** [Description]
**What we are doing:** [Actions]
**What you should do:** [Customer actions if any]

### Regulatory Notification (if applicable)
**To:** [Regulatory Authority]
**Date of Incident:** 2026-08-16
**Type:** ransomware
**Measures Taken:** [Actions]
**Contact:** [DPO / Incident Manager]

### Resolution Notice
**Subject:** Incident Resolved - ransomware
**Root cause:** [Description]
**Actions taken:** [List]
**Future prevention:** [Steps]

---

## References

- NIST SP 800-61 Rev. 2 (Computer Security Incident Handling Guide)
- NIST SP 800-86 (Guide to Integrating Forensic Techniques into Incident Response)
- SANS Incident Response Process
- ISO/IEC 27035 (Information security incident management)
- CISA Cyber Incident Response Plan Template