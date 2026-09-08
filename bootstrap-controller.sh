#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y python3-venv openssh-client curl
python3 -m venv "$HOME/ansible-venv"
"$HOME/ansible-venv/bin/pip" install 'ansible-core>=2.19,<2.21'
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -N '' -f "$HOME/.ssh/id_ed25519" -C sjsu-ansible-controller
fi
echo 'Copy the public key to student on both VMs with ssh-copy-id.'
echo 'Activate Ansible with: source ~/ansible-venv/bin/activate'
