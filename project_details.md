# Project Details: Hybrid Infrastructure Pipeline & Multi-Cloud Routing Lab

## Executive Summary
This project is an automated, end-to-end engineering environment that bridges Infrastructure-as-Code (Terraform & Ansible) with a containerized multi-router network lab (Free Range Routing / FRR). It models production-grade hybrid cloud architectures and automated deployment pipelines.

---

## Application Architecture & Purpose

### 1. Terraform Layer (Foundational Provisioning & Drift Management)
* **What it does:** Provisions base infrastructure configurations and generates compliance/node definition files (`managed_nodes.cfg`) with built-in drift detection.
* **Application Support:** Models enterprise provisioning workflows, ensuring immutable infrastructure baselines, environment reproducibility, and strict compliance before any application or network workload goes live.

### 2. Ansible Layer (System Hardening & Configuration Management)
* **What it does:** Automatically applies system compliance reports, hardens local execution targets, and deploys configuration templates to runtime containers.
* **Application Support:** Enforces security benchmarks and guarantees consistent configuration states across all deployment targets without manual intervention.

### 3. Containerized Routing Lab Layer (FRR / OSPF / eBGP)
* **What it does:** Deploys containerized enterprise routers (`enterprise-router-1` and `enterprise-router-2`) running Free Range Routing (FRR) over a Docker bridge network.
* **Application Support:** Simulates multi-region cloud interconnects and hybrid data center routing. It models how distributed microservices handle dynamic path selection, gateway redundancy, autonomous system (AS) peering, and automated failover when network links drop.

---

## Pipeline Execution Flow (`run_pipeline.sh`)

The custom orchestration script executes a rigorous 7-stage automated pipeline:
1. **Git Validation:** Ensures working tree cleanliness and prompts for confirmation if uncommitted changes exist.
2. **Terraform Initialization:** Prepares the IaC backend and provider plugins.
3. **Drift Analysis (`terraform plan`):** Validates real infrastructure state against configuration.
4. **Manual Approval Gate:** Safe interactive pause for operator review before applying changes.
5. **Terraform Apply:** Executes infrastructure updates.
6. **Ansible Hardening & Deployment:** Applies compliance policies and provisions routing containers via Docker Compose.
7. **Protocol Health Verification:** Pauses for convergence (`sleep 5`) and validates live BGP (`show ip bgp summary`) and OSPF (`show ip ospf neighbor`) states via `vtysh`.
