# VirtualBox setup used for this assignment

Host: Windows PC with an AMD Ryzen 5 3600. AMD SVM virtualization must be enabled in firmware.

| Setting | VM1 | VM2 |
|---|---|---|
| OS installation ISO | Ubuntu 26.04.1 Desktop amd64 | Ubuntu 26.04.1 Desktop amd64 |
| Memory | 4096 MB | 4096 MB |
| CPUs | 2 | 2 |
| Virtual disk | 25 GB | 30 GB |
| Adapter 1 | NAT | NAT |
| Adapter 2 | VirtualBox Host-Only Ethernet Adapter | VirtualBox Host-Only Ethernet Adapter |
| Host-only address | 192.168.56.101/24 | 192.168.56.102/24 |
| Linux username | student | student |
| Role | Ansible controller and webserver | Webserver |

The Windows host has 192.168.56.1 on the host-only network. NAT allows the guests to download packages, and the host-only network allows Windows to open both web pages directly on port 8080. No NAT port forwarding is needed.

On each guest, the network configuration uses DHCP on enp0s3 and its static host-only address on enp0s8. OpenSSH server and Python 3 are installed. The student user has sudo permission for this dedicated lab. VM1 uses an SSH key to manage both guests.

For a fresh installation, create a VM with the settings above, install Ubuntu onto its virtual disk, then configure networking, OpenSSH, and the student account. Run bootstrap-controller.sh on VM1 and authorize its public SSH key on both VMs. The README describes the deployment commands.

Passwords, private keys, installation files containing password hashes, and virtual disks are not included in this repository.
