#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p evidence
exec > >(tee "evidence/demo-$(date +%Y%m%d-%H%M%S).log") 2>&1
echo 'Two VM Ansible demonstration'
date -Is
ansible --version
ansible-inventory --graph
ansible webservers -m ping
ansible-playbook site.yml --syntax-check
ansible-playbook site.yml --tags deploy
echo 'Repeat deployment to verify idempotence'
ansible-playbook site.yml --tags deploy
for n in 1 2; do curl --fail --silent "http://192.168.56.10${n}:8080/"; done
echo 'Remove assignment resources'
ansible-playbook site.yml --tags undeploy
for n in 1 2; do
  if curl --fail --silent --max-time 5 "http://192.168.56.10${n}:8080/"; then
    echo "ERROR: VM${n} still serves HTTP"; exit 1
  else
    echo "VM${n}: HTTP unavailable after undeploy as expected"
  fi
done
echo 'Repeat removal to verify it is safe to rerun'
ansible-playbook site.yml --tags undeploy
echo 'Restore both webservers for browser demonstration'
ansible-playbook site.yml --tags deploy
