# Rook/Ceph on big HA K8s Cluster

This doc explains about Rook/Ceph used big HA K8s Clsuter.

## PREPARE

K8s master role share VMs with K8s worker role in minimum HA K8s cluster.

You need build 6 or more VMs.

* Notes
    * __You must build 3 or more VMs for K8s Master role.__
    * __You must build 3 or more VMs for K8s Worker role.__
    * __You must attach 3 or more storage devices exclude OS drive, which it is 20GB or more.__


I have tested it in the following environments.

|                          |       K8s Master VM        |       K8s Worker VM        |
| ------------------------ | -------------------------- | -------------------------- |
|     __number of VM__     |              3             |              6             |
| __capacities of memory__ |             6GB            |             12GB           |
|       __CPU core__       |           4 vcpu           |           4 vcpu           |
|          __OS__          |    Ubuntu Serever 18.04    |    Ubuntu Serever 18.04    |
| __number of device exclude OS drive__ |       3       |              6             |
| __capacities of device exclude OS drive <br> in all VMs__ |x|        20GB          |

## CREATE

Using variable list

* VM_UNAME: ssh user name
* SSH_CONF_PATH: full path of ssh config in client
* SSH_KEY_PATH: full path of ssh public key in client
* VM_SUDO_PASS: sudo password in vm
* KUBE_VIP: vip of kube-apiserver

1. Edit ssh config in client machine.

    Following example, add ssh information to your client ssh confing file.(example path $HOME/.ssh/config)

    ```$HOME/.ssh/config    
    Host vm-m0
      Hostname xxx.xxx.xxx.xxx
      User $VM_UNAME
    Host vm-m1
      Hostname xxx.xxx.xxx.xxx
      User $VM_UNAME
    Host vm-m2
      Hostname xxx.xxx.xxx.xxx
      User $VM_UNAME    
    Host vm-w0
      Hostname xxx.xxx.xxx.xxx
      User $VM_UNAME
    Host vm-w1
      Hostname xxx.xxx.xxx.xxx
      User $VM_UNAME
    Host vm-w2
      Hostname xxx.xxx.xxx.xxx
      User $VM_UNAME
    Host vm-w3
      Hostname xxx.xxx.xxx.xxx
      User $VM_UNAME
    Host vm-w4
      Hostname xxx.xxx.xxx.xxx
      User $VM_UNAME
    Host vm-w5
      Hostname xxx.xxx.xxx.xxx
      User $VM_UNAME      
    ```

2. Edit hosts.yaml

    Following example, edit minimum_hosts.yaml.

    ```yaml
    vm-m0:
        ansible_ssh_user: $VM_UNAME
    vm-m1:
        ansible_ssh_user: $VM_UNAME
    vm-m2:
        ansible_ssh_user: $VM_UNAME    
    vm-w0:
        ansible_ssh_user: $VM_UNAME
    vm-w1:
        ansible_ssh_user: $VM_UNAME
    vm-w2:
        ansible_ssh_user: $VM_UNAME
    vm-w3:
        ansible_ssh_user: $VM_UNAME
    vm-w4:
        ansible_ssh_user: $VM_UNAME
    vm-w5:
        ansible_ssh_user: $VM_UNAME        
    ```

3. Run shell script

    This Playbook can build 2 type ceph cluster.

    1. cephfs

        ```sh
        $ ./create.sh $SSH_CONF_PATH $SSH_KEY_PATH $VM_SUDO_PASS $KUBE_VIP
        ```

        Answer password to use ansible-vault.

        ```sh
        New Vault password: 
        Confirm New Vault password:
        ```

    2. rbd

        ```sh
        $ $ ./create.sh $SSH_CONF_PATH $SSH_KEY_PATH $VM_SUDO_PASS $KUBE_VIP rbd
        ```

        Answer password to use ansible-vault.

        ```sh
        New Vault password: 
        Confirm New Vault password:
        ```

    Success!!!
    ```sh
    vm-m0@vm-m0:~$ k get pod -n rook-ceph 
    NAME                                                            READY   STATUS      RESTARTS   AGE
    csi-cephfsplugin-4qktn                                          3/3     Running     0          6m5s
    csi-cephfsplugin-bgbbz                                          3/3     Running     0          6m5s
    csi-cephfsplugin-provisioner-598854d87f-hkh6b                   6/6     Running     0          6m5s
    csi-cephfsplugin-provisioner-598854d87f-slp88                   6/6     Running     0          6m5s
    csi-cephfsplugin-qf58w                                          3/3     Running     0          6m5s
    csi-rbdplugin-f7sc2                                             3/3     Running     0          6m6s
    csi-rbdplugin-provisioner-dbc67ffdc-8qlxm                       6/6     Running     0          6m6s
    csi-rbdplugin-provisioner-dbc67ffdc-p2j6l                       6/6     Running     0          6m6s
    csi-rbdplugin-t8rmv                                             3/3     Running     0          6m6s
    csi-rbdplugin-tm6d5                                             3/3     Running     0          6m6s
    rook-ceph-crashcollector-vm-w6-fc7db7dfd-lr427                  1/1     Running     0          2m3s
    rook-ceph-crashcollector-vm-w7-f7bccb647-n2wc2                  1/1     Running     0          45s
    rook-ceph-crashcollector-vm-w8-6b7f66c558-jx295                 1/1     Running     0          46s
    rook-ceph-mds-myfs-a-56c9b77c8c-4pfjx                           1/1     Running     0          46s
    rook-ceph-mds-myfs-b-c7c66f5cf-2vvzr                            1/1     Running     0          45s
    rook-ceph-mgr-a-68f4dcf897-whgf8                                1/1     Running     0          2m34s
    rook-ceph-mon-a-7d8f875996-htcgp                                1/1     Running     0          5m6s
    rook-ceph-mon-b-bc9c4666-czh6s                                  1/1     Running     0          4m
    rook-ceph-mon-c-58f7cdbd54-6tkpl                                1/1     Running     0          3m2s
    rook-ceph-operator-58496b74f9-zn99v                             1/1     Running     0          9m1s
    rook-ceph-osd-0-687bf76bbd-vpht8                                1/1     Running     0          2m3s
    rook-ceph-osd-1-55d7ccdd57-4568l                                1/1     Running     0          118s
    rook-ceph-osd-10-d74bf9c9d-t9kv4                                1/1     Running     0          104s
    rook-ceph-osd-11-7b944c64c7-qv26c                               1/1     Running     0          100s
    rook-ceph-osd-2-77f858c4cb-z9vz9                                1/1     Running     0          2m1s
    rook-ceph-osd-3-5bb657867d-mlb6z                                1/1     Running     0          116s
    rook-ceph-osd-4-5895c75f9c-tzfvz                                1/1     Running     0          115s
    rook-ceph-osd-5-b7ffc996c-9s4fn                                 1/1     Running     0          112s
    rook-ceph-osd-6-5757d8ffdb-mj4j2                                1/1     Running     0          110s
    rook-ceph-osd-7-5d6869d557-fmw4f                                1/1     Running     0          108s
    rook-ceph-osd-8-55ff54889f-cxhv7                                1/1     Running     0          106s
    rook-ceph-osd-9-879fb598c-j2hpl                                 1/1     Running     0          102s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-0-cndmd-fpwtg    0/1     Completed   0          2m26s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-1-g4ngq-xrx6v    0/1     Completed   0          2m25s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-10-t7m5z-6hcxp   0/1     Completed   0          2m22s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-11-gd2w2-dgbkz   0/1     Completed   0          2m21s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-2-ddjk7-mvrt7    0/1     Completed   0          2m25s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-3-zlqct-qww5p    0/1     Completed   0          2m24s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-4-tb99q-g6jm2    0/1     Completed   0          2m24s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-5-9rfw9-vnclj    0/1     Completed   0          2m24s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-6-j96wb-mkdgf    0/1     Completed   0          2m23s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-7-jb249-x2sn4    0/1     Completed   0          2m23s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-8-kfhqv-lqw85    0/1     Completed   0          2m22s
    rook-ceph-osd-prepare-topolvm-ssd-cluster-data-9-gt8sr-gpmqp    0/1     Completed   0          2m22s
    rook-ceph-tools-6bdcd78654-vkjd2                                1/1     Running     0          76s
    rook-discover-c5wfx                                             1/1     Running     0          8m14s
    rook-discover-dqvbq                                             1/1     Running     0          8m14s
    rook-discover-k9dkc                                             1/1     Running     0          8m14s    
    ```

## DELETE

1. cephfs

    ```sh
    $ ansible-playbook -i hosts delete-cluster.yaml
    ```

2. rbd

    ```sh
    $ ansible-playbook -i hosts delete-cluster.yaml -e ceph_type=rbd
    ```