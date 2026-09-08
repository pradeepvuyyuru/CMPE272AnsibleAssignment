#!/usr/bin/env bash
set -euo pipefail
source "$HOME/ansible-venv/bin/activate"
cd "$HOME/ansible-assignment"
mkdir -p evidence
export ANSIBLE_FORCE_COLOR=1
exec > >(tee evidence/interactive-demo.log) 2>&1
pause_demo() { printf '\nPress Enter for the next step...'; read -r; }
clear
echo 'CMPE 272 - Pradeep Vuyyuru - Two VM Ansible Demo'
date -Is
ansible --version | head -n 1
cat inventory.ini
ansible webservers -m ping
pause_demo
clear
echo 'DEPLOY - Install and start webservers on both VMs'
ansible-playbook site.yml --syntax-check
ansible-playbook site.yml --tags deploy
pause_demo
clear
echo 'REPEAT DEPLOY - Check changed=0 for both hosts'
ansible-playbook site.yml --tags deploy
pause_demo
clear
echo 'HTTP CHECK - VM1 and VM2 on port 8080'
for n in 1 2; do
  echo "VM${n}: http://192.168.56.10${n}:8080"
  curl -fsS "http://192.168.56.10${n}:8080/" | sed 's/<[^>]*>/ /g' | grep 'Hello World'
done
echo 'Open both addresses in a browser to verify the pages.'
pause_demo
clear
echo 'UN-DEPLOY - Remove service, files, and nginx packages'
ansible-playbook site.yml --tags undeploy
for n in 1 2; do
  if curl -fsS --max-time 5 "http://192.168.56.10${n}:8080/" >/dev/null 2>&1; then
    echo "ERROR: VM${n} is still serving HTTP"; exit 1
  else
    echo "VM${n}: port 8080 unavailable, as expected"
  fi
done
pause_demo
clear
echo 'REPEAT UN-DEPLOY - Already absent resources stay absent'
ansible-playbook site.yml --tags undeploy
pause_demo
clear
echo 'RESTORE - Deploy again after removal'
ansible-playbook site.yml --tags deploy
for n in 1 2; do
  echo "VM${n}: http://192.168.56.10${n}:8080"
  curl -fsS "http://192.168.56.10${n}:8080/" | sed 's/<[^>]*>/ /g' | grep 'Hello World'
done
echo 'Demo complete. Both webservers are running.'
pause_demo
