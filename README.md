# Local Infrastructure Pipeline & Multi-Cloud Routing Lab

An automated, end-to-end engineering environment that bridges Infrastructure-as-Code (Terraform & Ansible) with a containerized multi-router network lab (Free Range Routing / FRR).

---

## Application Architecture & Purpose

This project simulates a production-grade hybrid cloud environment, mapping out how different layers support modern distributed applications:

### 1. Terraform Layer (Foundational Provisioning & Drift Management)
* What it does: Provisions base infrastructure configurations and generates compliance/node definition files (managed_nodes.cfg) with built-in drift detection.
* Application Support: Models enterprise provisioning workflows, ensuring immutable infrastructure baselines, environment reproducibility, and strict compliance before any application or network workload goes live.

### 2. Ansible Layer (System Hardening & Configuration Management)
* What it does: Automatically applies system compliance reports, hardens local execution targets, and deploys configuration templates to runtime containers.
* Application Support: Enforces security benchmarks and guarantees consistent configuration states across all deployment targets without manual intervention.

### 3. Containerized Routing Lab Layer (FRR / OSPF / eBGP)
* What it does: Deploys containerized enterprise routers (enterprise-router-1 and enterprise-router-2) running Free Range Routing (FRR) over a Docker bridge network.
* Application Support: Simulates multi-region cloud interconnects and hybrid data center routing. It models how distributed microservices handle dynamic path selection, gateway redundancy, autonomous system (AS) peering, and automated failover when network links drop.

---

## Pipeline Execution Flow

The custom orchestration script (run_pipeline.sh) executes a rigorous 7-stage automated pipeline:
1. Git Validation: Ensures working tree cleanliness.
2. Terraform Initialization: Prepares the IaC backend.
3. Drift Analysis (terraform plan): Validates infrastructure state.
4. Manual Approval Gate: Safe interactive pause for operator review.
5. Terraform Apply: Executes infrastructure updates.
6. Ansible Hardening & Deployment: Applies compliance policies and provisions routing containers.
7. Protocol Health Verification: Pauses for convergence (sleep 5) and validates live BGP (show ip bgp summary) and OSPF (show ip ospf neighbor) states via vtysh.

---

## Getting Started

##Run the complete end-to-end automated pipeline:
```bash
./run_pipeline.sh
