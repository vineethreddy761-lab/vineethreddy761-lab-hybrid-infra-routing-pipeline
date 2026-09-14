#!/bin/bash
set -e

echo "=== STAGE 0: Git Working Tree Validation ==="
if [[ -n $(git status --porcelain) ]]; then
    echo "WARNING: You have uncommitted changes in your git repository."
    read -p "Do you wish to continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Pipeline aborted due to uncommitted git changes."
        exit 1
    fi
else
    echo "Git working tree is clean."
fi

echo "=== STAGE 1: Terraform Initialization ==="
cd terraform
terraform init -upgrade

echo "=== STAGE 2: Terraform Plan (Drift Analysis) ==="
terraform plan -out=tfplan.binary

echo "=== STAGE 3: Manual Approval Gate Simulation ==="
read -p "Do you want to proceed with Terraform Apply? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Pipeline aborted by user at approval gate."
    exit 1
fi

echo "=== STAGE 4: Terraform Apply ==="
terraform apply tfplan.binary

echo "=== STAGE 5: Ansible Configuration & Hardening ==="
cd ../ansible
ansible-playbook hardening.yml

echo "=== STAGE 6: Containerized Routing Lab Deployment ==="
cd ..
ansible-playbook ansible/playbook.yml -i ansible/inventory

echo "=== STAGE 7: Live Routing & Protocol Health Verification ==="
echo "Waiting 5 seconds for OSPF and BGP neighbor convergence..."
sleep 5
docker exec enterprise-router-2 vtysh -c "show ip bgp summary"
docker exec enterprise-router-2 vtysh -c "show ip ospf neighbor"

echo "=== COMPLETE END-TO-END PIPELINE FINISHED SUCCESSFULLY ==="
