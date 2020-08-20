#!/bin/bash

# create ansible.cfg

echo "------------------------------"
echo "set following value"
echo "ssh config path: "$1
echo "ssh public key: "$2
echo "kube-apiserver vip: "$3
echo "------------------------------"


echo -n "[defaults]
ask_vault_pass = True
host_key_checking = False

[ssh_connection]
ssh_args = -F "$1 > ansible.cfg

echo -n "- name: register public key.
  become: yes
  authorized_key:
    user: \"{{ item }}\"
    state: present
    key: \"{{ lookup('file', '"$2"') }}\"
  with_items:
    - \"{{ ansible_ssh_user }}\"" > roles/ssh-copy-id/tasks/ssh.yaml

echo -n "ansible_sudo_pass: "$3 > group_vars/all/vault.yaml

ansible-vault encrypt group_vars/all/vault.yaml

echo -n "keepalived_configuration:
  ROUTER_ID: \"51\"
  AUTH_PASS: \"123\"
  APISERVER_VIP: \""$4"\"" > group_vars/all/keepalived_conf.yaml

ansible-playbook -i minimum_hosts.yaml prepare.yaml -k

if [ -n "$5" ];then
  if [ $5 == 'rbd' ];then
    echo "----------"
    echo "rbd mode"
    echo "----------"
    ansible-playbook -i minimum_hosts.yaml create-cluster.yaml -e ceph_type=rbd
  fi
else
  echo "------------"
  echo "cephfs mode"
  echo "------------"
  ansible-playbook -i minimum_hosts.yaml create-cluster.yaml
fi