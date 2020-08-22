# ansible-rook-ceph

Ansible-rook-ceph is an ansible playbook for bare metal server.

This playbook construct 2 components.
1. Multi Master [Kubernetes](https://github.com/kubernetes/kubernetes) Cluster
2. [Rook](https://github.com/rook/rook)/Ceph


* README in Japanese.

    [てんぜんの生存日記](https://tenzen.hatenablog.com/entry/2020/08/20/203448)

## Notes

* __All VMs must access to network.__
* __All VMs must be running ssh server.__
* __Client machine must be installed sshpass.__

If create VMs by ESXi, you must check the following document.

[Creating VMs by ESXi](docs/trouble_shoot.md#creating-vms-by-esxi)

## Quick Start Guide

* [minimum cluster](docs/minimum.md)

* [big cluster](docs/big.md)

* [trouble shoot](docs/trouble_shoot.md)