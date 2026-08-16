{{INCIDENT_TYPE}}

{{SEVERITY}}

{{ROLES_TABLE}}

{{PHASES_CONTENT}}

## Communication Templates

{{COMMUNICATION_TEMPLATES}}

## Evidence Collection Guidelines

| Evidence Type | Source | Collection Method | Chain of Custody |
|---------------|--------|-------------------|------------------|
| System logs | SIEM, syslog, Event Viewer | Forensic copy (bit-for-bit) | Document who, when, where collected |
| Network captures | pcap, netflow | tcpdump, Wireshark | Hash the capture file (SHA-256) |
| Memory dumps | RAM | FTK Imager, LiME, WinPmem | Record system state before collection |
| Disk images | Hard drives, SSDs | dd, FTK Imager, Guymager | Write-protect source, use blockchain hash |
| Email headers | Mail server, client | Export .EML/.MSG, preserve headers | Log access and timestamps |
| Application logs | Web/app servers | Collector agent, manual export | Maintain unaltered original copies |
| Cloud logs | AWS CloudTrail, Azure Monitor | API export, S3 bucket replication | Enable log immutability if available |

### Chain of Custody Form

| Field | Value |
|-------|-------|
| Evidence ID | |
| Collector Name | |
| Collection Date/Time | |
| Source Location | |
| Hash (SHA-256) | |
| Transferred To | |
| Transfer Date/Time | |
| Purpose of Transfer | |
| Return Date/Time | |

## Severity Classification Matrix

| Severity | Definition | Response SLA | Examples |
|----------|-----------|-------------|----------|
| **CRITICAL** | Active compromise of critical systems with confirmed data exfiltration or ransomware encryption | < 15 min notification, continuous response | Ransomware, APT breach, payment data loss |
| **HIGH** | Active compromise of non-critical systems or confirmed vulnerability with high exploitation likelihood | < 1 hour notification, immediate investigation | Unauthorized admin access, phishing with credential theft |
| **MEDIUM** | Suspected compromise or vulnerability with moderate impact | < 4 hours notification, investigate within 24h | Policy violation, single workstation malware, scanning activity |
| **LOW** | Minimal impact, no sensitive data at risk | < 24 hours notification, investigate within 72h | Spam campaign, port scan, minor policy violation |

## Role Definitions with RACI

| Role | Responsibility | R | A | C | I |
|------|---------------|---|---|---|---|
| **Incident Manager** | Oversees entire IR process, makes strategic decisions, coordinates resources | ✓ | | | |
| **Technical Lead** | Leads technical investigation, containment, eradication, and recovery | | ✓ | | |
| **Communications Lead** | Manages internal/external communications, regulatory notifications | | | ✓ | |
| **Legal Counsel** | Advises on legal obligations, data breach notification laws, privilege | | | | ✓ |
| **Forensics Analyst** | Collects and analyzes evidence, maintains chain of custody | | | ✓ | |
| **HR Representative** | Handles personnel-related aspects (insider threats, policy violations) | | | | ✓ |
| **PR / Media** | Prepares public statements, manages media inquiries | | | | ✓ |
| **System Owners** | Provide access, knowledge, and support for affected systems | | ✓ | | |
| **CISO / Executive** | Approves public communications, escalations, resource allocation | | ✓ | | |