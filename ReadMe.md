# Unattended SAP GUI Automation (VBA)

## Overview
This project demonstrates how a complex, SAP GUI–based business workflow can be transformed into a **fully unattended automation** using VBA and Excel as an orchestration layer.

The focus of this project is not simple GUI scripting, but:
- Robust exception handling
- COM / OLE dialog suppression
- Reliable overnight execution without human intervention

This reflects real-world enterprise automation constraints where APIs are unavailable and GUI automation is the only viable option.

---

## Business Problem
A large number of SAP material master records needed to be processed to extract:
- Material attributes
- Quality and condition information
- Pricing and reference data
- Associated documents

Manual processing was:
- Time-consuming
- Error-prone
- Not scalable

Partial automation attempts failed due to **OLE / COM dialog interruptions**, which required human clicks and broke unattended execution.

---

## Key Challenges
- SAP GUI automation without API access
- Excel ↔ SAP COM instability
- OLE warning dialogs blocking execution
- Requirement for **zero human interaction**

---

## Solution Approach
The solution was designed using a **Divide & Conquer** philosophy:

1. Excel acts as the controller and task queue
2. VBA serves as the automation engine
3. SAP GUI is treated as the system of record
4. Each automation step is isolated, validated, and recoverable
5. COM / OLE interruptions are explicitly handled and suppressed
6. Automation runs fully unattended (overnight capable)

---

## Architecture
Excel (Controller)

↓

VBA Automation Engine

↓

SAP GUI Session

↓

Data Extraction & File Automation

↓

Validation & Logging


---

## Results
- Thousands of records processed automatically
- Overnight execution with no human intervention
- Deterministic, repeatable output
- Significant reduction in manual workload and operational risk

---

## Skills Demonstrated
- ERP workflow analysis (SAP GUI)
- VBA automation architecture
- COM / OLE exception handling
- Unattended automation design
- File system automation and validation
- Defensive programming in enterprise environments

---

## Disclaimer
This repository contains **mocked and generalized code** only.
No proprietary SAP data, credentials, or internal business logic are included.
