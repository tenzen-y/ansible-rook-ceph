# README

This playbook construct
1. Multi Master K8s Cluster
2. Rook/Ceph

## prepare

  * __All VM must access network.__
  * __All Vm must run ssh server.__
  * __Every K8s Worker VM must have 3 storage devices exclude OS Drive, which it is over 20GB.__
  * __Client machine must be installed sshpass.__

I have verified the operation with the following configuration.

|         |  K8s Master VM  |  K8s Worker VM  |
| ---- | ---- | ---- |
|number of VM|3|6|
|capacities of memory|  6GB  |  12GB  |
|CPU core|  4 vcpu  |  4 vcpu  |
|OS|Ubuntu Serever 18.04|Ubuntu Serever 18.04|
|number of device exclude OS drive|0|3|
|capacities of device exclude OS drive in every K8s Worker VM|x|20GB|


## create Rook/Ceph

1. edit hosts.yaml

* VM_UNAME: ssh user name

    ```hosts.yaml
    vm-m0:
        ansible_ssh_user: $VM_UNAME
    ```

2. edit ssh config

* example

    ```config
    Host vm-m0
    Hostname xxx.xxx.xxx.xxx
    User vm-m0
    ```

3. running ansible-playbook

* SSH_CONF_PATH: full path of ssh config
* SSH_KEY_PATH: full path of ssh public key
* VM_SUDO_PASS: sudo password in vm
* KUBE_VIP: vip of kube-apiserver

1. create cephfs

    ```bash
    $ ./create.sh $SSH_CONF_PATH $SSH_KEY_PATH $VM_SUDO_PASS $KUBE_VIP
    ```

2. create rbd

    ```bash
    $ ./create.sh $SSH_CONF_PATH $SSH_KEY_PATH $VM_SUDO_PASS $KUBE_VIP -e ceph_type=rbd
    ```

## Delete Rook/Ceph

```bash
$ ansible-playbook -i hosts delete-cluster.yaml
```