# CMPE 272 - Two-VM Ansible webservers

I used Ansible to deploy nginx on two Ubuntu VMs in VirtualBox. Both serve a page on port 8080, with a different SJSU message on each VM.

The deployment, repeat deployment, un-deployment, repeat un-deployment, and redeployment all passed on both hosts. The repeat runs reported changed=0.

- [Word report with screenshots](Pradeep_Vuyyuru_Ansible_Assignment.docx)
- [Recorded demo, 3 minutes 9 seconds, no audio](demo.webm)
- [Actual command output](evidence/interactive-demo.log)
- [VM setup](VM-SETUP.md)

VM1: http://192.168.56.101:8080/

VM2: http://192.168.56.102:8080/

These addresses work from the Windows host while the VMs are running. The recorded demo is available for viewing elsewhere.

On the configured VM1, run:

```bash
source ~/ansible-venv/bin/activate
cd ~/ansible-assignment
bash demo-interactive.sh
```

## Environment

Use two dedicated Ubuntu 26.04.1 LTS VMs named VM1 and VM2, with 4 GB RAM each and 25 GB and 30 GB disks respectively. Install OpenSSH server and Python 3 on both. Use a Linux control node (VM1 may also be the control node). The controller must reach both VMs over SSH; your browser must reach both on TCP 8080. For VirtualBox, use a NAT adapter for package downloads plus a host-only adapter for host/controller communication. Put the host-only IPv4 addresses in the inventory. For cloud VMs, permit TCP 22 from the controller and TCP 8080 from your browser's source IP in the cloud firewall. If UFW is enabled, allow those connections there too. Do not disable the firewall.

On an Ubuntu controller:

```bash
sudo apt-get update
sudo apt-get install -y python3-venv openssh-client
python3 -m venv .venv
. .venv/bin/activate
pip install 'ansible-core>=2.19,<2.21'
```

Copy this directory onto the controller. Copy inventory.ini to inventory.local.ini and adjust the IP addresses and SSH username if your setup differs. Configure key-based SSH and verify each host fingerprint on first connection. Do not commit private keys. The user needs sudo rights (add `--ask-become-pass` to commands if sudo requires a password).

## Deploy and verify

```bash
ansible-inventory -i inventory.local.ini --graph
ansible -i inventory.local.ini webservers -m ping
ansible-playbook -i inventory.local.ini site.yml --syntax-check
ansible-playbook -i inventory.local.ini site.yml --tags deploy
ansible-playbook -i inventory.local.ini site.yml --tags deploy
```

The second deployment should report changed=0 on both hosts when inputs are unchanged. Open `http://VM1_IP:8080` and `http://VM2_IP:8080` in a browser. Verify the exact respective messages, Hello World from SJSU-1 and Hello World from SJSU-2. Internal URI checks verify responses on the VMs; browser checks additionally verify network accessibility.

## Un-deploy and redeploy

```bash
ansible-playbook -i inventory.local.ini site.yml --tags undeploy
ansible-playbook -i inventory.local.ini site.yml --tags undeploy
ansible-playbook -i inventory.local.ini site.yml --tags deploy
```

Un-deploy stops/disables the assignment service and removes its unit, configuration, and page directory. It verifies TCP 8080 is closed. The nginx and nginx-common packages are purged because these are dedicated lab VMs. Refresh both browser tabs after un-deploy to show connection failures. Redeploy for the final demo.

Both plays use the special `never` tag plus an explicit action tag, so a command without tags does not deploy and immediately remove the application. Do not pass both action tags together.

## Demo and evidence (approximately 3–5 minutes)

1. Show two running VMs, their names, and their distinct IP addresses.
2. Show inventory and explain instance_id, then show Ansible ping success.
3. Run deploy; capture the successful recap for both hosts.
4. Show both browser address bars with port 8080 and the respective messages.
5. Run deploy again and show changed=0.
6. Run undeploy, show its recap, and refresh both browser pages to show failure.
7. Redeploy and show both pages restored.
8. Show the GitHub repository with all code and link it in the Word document. If a recorded demo is required, record this sequence and put its accessible link in the report.

## GitHub submission

This assignment is published at https://github.com/pradeepvuyyuru/CMPE272AnsibleAssignment. For a separate copy in your own empty repository, run from this folder (replace the URL):

```bash
git init
git add .
git commit -m "Add two-VM Ansible webserver assignment"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

Review staged files before committing. Include the completed report and real evidence if allowed by the course. Verify the instructor can access the repository and demo.

References: https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_tags.html and https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/apt_module.html
