# CMPE 272 Ansible Assignment

I set up two Ubuntu VMs in VirtualBox and used Ansible on VM1 to install nginx on both. Each page runs on port 8080:

- VM1: http://192.168.56.101:8080 shows "Hello World from SJSU-1"
- VM2: http://192.168.56.102:8080 shows "Hello World from SJSU-2"

I gave each VM 4 GB of RAM and two CPUs, with NAT for internet access and a host-only adapter for communication. I set up SSH keys and sudo access for the student account. These addresses work on my computer while the VMs are running.

I run these commands from VM1:

```bash
source ~/ansible-venv/bin/activate
cd ~/ansible-assignment

# Deploy
ansible-playbook site.yml --tags deploy

# Un-deploy
ansible-playbook site.yml --tags undeploy
```

I checked both pages in a browser, removed the webservers, and deployed them again successfully.

- [My report and screenshots](Pradeep_Vuyyuru_Ansible_Assignment.docx)
- [My recorded demo](demo.webm)
