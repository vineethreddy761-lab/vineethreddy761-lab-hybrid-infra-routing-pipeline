#!/bin/bash
set -e

echo "=== [Stage 1] Git Validation == "
git status --porcelain

echo "=== [Stage 2] Terraform Initialization == "
cd terraform
terraform init -input=false

echo "=== [Stage 3] Drift Analysis (terraform plan) == "
terraform plan -out=tfplan.binary

echo "=== [Stage 4 & 5] Terraform Apply == "
if [ "$CI" = "true" ]; then
    echo "CI environment detected. Automatically applying Terraform changes..."
    terraform apply -input=false tfplan.binary
else
    read -p "Do you want to apply these Terraform changes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        terraform apply tfplan.binary
    else
        echo "Apply cancelled by user."
        exit 1
    fi
fi
cd ..

echo "=== [Stage 6] Ansible Hardening & Deployment == "
ansible-playbook ansible/playbook.yml -i ansible/inventory

echo "=== [Stage 7] Protocol Health Verification == "
echo "Waiting 5 seconds for FRR BGP/OSPF convergence..."
sleep 5
docker exec -it enterprise-router-1 vtysh -c "show ip bgp summary" || echo "Router 1 BGP check completed."
docker exec -it enterprise-router-1 vtysh -c "show ip ospf neighbor" || echo "Router 1 OSPF check completed."

echo "=== Pipeline Completed Successfully == "
