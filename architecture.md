# Hybrid Infrastructure & Routing Lab - Architecture & Design

## 1. Overview
This repository implements an automated, end-to-end hybrid infrastructure and routing laboratory pipeline. It integrates **Infrastructure-as-Code (Terraform)**, **Configuration Management & Hardening (Ansible)**, and **Containerized Dynamic Routing (FRRouting with OSPF and BGP)** into a unified, version-controlled repository with automated CI/CD validation via GitHub Actions.

---

## 2. High-Level Architecture Diagram

text
+-----------------------------------------------------------------------+
|                         GitHub Actions CI/CD                          |
|  - Automated Validation (Terraform Init/Validate, Ansible Syntax Check) |
|  - Orchestrated Execution via run_pipeline.sh                        |
+-----------------------------------------------------------------------+
|
v
+-----------------------------------------------------------------------+
|                         Orchestration Pipeline                        |
|                   (run_pipeline.sh / Local & CI Execution)            |
+-----------------------------------------------------------------------+
|                                 |
v                                 v
+---------------------------------+   +---------------------------------+
|        Terraform Engine         |   |         Ansible Engine          |
|  - State Management             |   |  - System Hardening             |
|  - Resource Provision           |   |  - Compliance Audits            |
+---------------------------------+   +---------------------------------+
|
v
+---------------------------------+
|       Docker Compose Lab        |
|  - FRR Router 1 (OSPF)          |
|  - FRR Router 2 (BGP)           |
+---------------------------------+


---

## 3. Core Components

### A. Infrastructure Provisioning (Terraform)
* **Role:** Manages local infrastructure configuration files, inventory generation bindings, and state compliance checks.
* **Files:** `terraform/main.tf`, `terraform/managed_nodes.cfg`.

### B. Configuration Management & Hardening (Ansible)
* **Role:** Applies security hardening baselines, manages configuration templates, and outputs compliance verification logs.
* **Playbooks:** `ansible/playbook.yml`, `ansible/hardening.yml`.
* **Inventory:** `ansible/inventory`.

### C. Containerized Routing Lab (FRR & Docker Compose)
* **Role:** Emulates enterprise routing nodes running OSPF and BGP protocols.
* **Topology:** `enterprise-router-1` and `enterprise-router-2` configured via `docker-compose.yml`.
* **Verification:** Validates dynamic neighbor convergence using `vtysh` command execution (`show ip bgp summary`, `show ip ospf neighbor`).

### D. Pipeline Automation (`run_pipeline.sh` & GitHub Actions)
* **Role:** Orchestrates the multi-stage deployment workflow from Git status validation and Terraform planning/applying to Ansible hardening and network protocol verification.
* **CI Workflow:** `.github/workflows/pipeline.yml`.

---

## 4. Execution Workflow
1. **Stage 1 & 2:** Git repository state validation and Terraform initialization (`terraform init`).
2. **Stage 3 & 4:** Terraform plan generation and automated/interactive apply.
3. **Stage 5 & 6:** Ansible playbook execution for system hardening and compliance logging.
4. **Stage 7:** Docker Compose deployment of FRR routers and protocol convergence validation (`vtysh`).
