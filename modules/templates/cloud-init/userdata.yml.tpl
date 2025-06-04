#cloud-config

%{ if hostname != "" }
# Set the hostname for this node
hostname: ${hostname}
%{ endif }

users:
- name: ${ssh_user}
  groups: sudo
  shell: /bin/bash
  sudo: ALL=(ALL) NOPASSWD:ALL
  ssh-authorized-keys:
  - ${ssh_public_key}

packages:
  - socat
  - conntrack

ntp:
  enabled: true
  servers:
  - 0.pool.ntp.org
  - 1.pool.ntp.org
  - 2.pool.ntp.org

runcmd:
  - ${runcmd} 