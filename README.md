# README

This playbook construct 2 components.
1. Multi Master K8s Cluster
2. Rook/Ceph

* readme.md in Japanese.

    [てんぜんの生存日記](https://tenzen.hatenablog.com/entry/2020/08/20/203448)

## prepare

  * __All VM must access network.__
  * __All Vm must run ssh server.__
  * __Every K8s Worker VM must have 3 or more storage devices exclude OS Drive, which it is 20GB or more.__
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

2. edit ssh config in client machine

* example

    ```config
    Host vm-m0
    Hostname xxx.xxx.xxx.xxx
    User vm-m0
    ```

3. running ansible-playbook

* SSH_CONF_PATH: full path of ssh config in client.
* SSH_KEY_PATH: full path of ssh public key in client.
* VM_SUDO_PASS: sudo password in vm
* KUBE_VIP: vip of kube-apiserver

1. create cephfs

    ```bash
    $ ./create.sh $SSH_CONF_PATH $SSH_KEY_PATH $VM_SUDO_PASS $KUBE_VIP
    ```

2. create rbd

    1. running shell script.

        ```bash
        $ ./create.sh $SSH_CONF_PATH $SSH_KEY_PATH $VM_SUDO_PASS $KUBE_VIP -e ceph_type=rbd
        ```
    2. answer password to use ansible-vault.

        ```bash
        ...
        New Vault password: 
        Confirm New Vault password:
        ```

## Delete Rook/Ceph

```bash
$ ansible-playbook -i hosts delete-cluster.yaml
```