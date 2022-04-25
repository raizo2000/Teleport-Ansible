# Teleport SSH with Ansible
This manual contains the installation and configuration of teleport for SSH use on different computers. 
The implementation of this node was done using multipass virtual machines.

## VM Comands
- VM Creation
```
multipass launch --name name-instance
multipass launch --name test-instance
```
- Details VMs
```
multipass exec name_vm -- lsb_release -a
```
- VM activate
```
multipass shell test-instance
```
- VM list
```
multipass list
```
# Requirements
For the correct implementation of this script, 
it is required Ubuntu server and the verification or installation of:
### - Curl intallation
```
sudo apt install curl
```
### - PIP intallation
```
sudo apt install python3-pip
```
### - Net Tools intallation
```
sudo apt install net-tools
```
For Teleport implementation with ansible, SSH connection permissions must exist.

## SSH Keys creation
The SSH key is not only for accessing our
dedicated servers, Cloud or VPS servers securely and through the command line. In this way, we can
In this way, we can work with the remote machines and perform all kinds of actions as if we were in front of them.
as if we were in front of them. In Linux, the process of creating SSH keys is very easy and in Windows, although it is not complex, it is very easy.
Windows, although it is not complex, we must have software to help us in this task.

### Master connection
```
ssh-keygen
cat ~/.ssh/id_rsa.pub
```
### Nodes connection
```
sudo nano ~/.ssh/authorized_keys
```
The key you created must be placed in the machines you are going to access.
### SSH Conection
```
ssh ubuntu@ip_node
```
### Close connection
```
exit
```
The deployment model allows the installation of one or several clusters, as well as the deployment of n nodes.

![ansible-teleport drawio (1)](https://user-images.githubusercontent.com/20120875/165179023-7d7f600f-b9ae-4c5e-9206-82b129bc56c6.png)

## Teleport
Teleport was designed to provide access to the infrastructure you need without slowing you down.
without slowing it down. With a single tool, engineers and security professionals get unified access to Linux and Windows servers
and Windows servers, Kubernetes clusters, databases and DevOps applications.
Kubernetes clusters, databases and DevOps applications such as CI/CD, version control and monitoring
version control and monitoring dashboards across all environments.

- Teleport needs diferents configuration to cluster and nodes
- The ansible script replace the files in the route /etc/teleport.yaml
## Cluster configuration
```
version: v2
teleport:
  nodename: primary
  data_dir: /var/lib/teleport
  log:
    output: stderr
    severity: INFO
    format:
      output: text
  ca_pin: []
  diag_addr: ""
auth_service:
  enabled: "yes"
  listen_addr: 0.0.0.0:3025
  cluster_name: cluster
  proxy_listener_mode: multiplex
ssh_service:
  enabled: "yes"
  labels:
    env: example
  commands:
  - name: hostname
    command: [hostname]
    period: 1m0s
proxy_service:
  enabled: "yes"
  listen_addr: 0.0.0.0:3023
  web_listen_addr: 192.168.64.2:3080
  tunnel_listen_addr: 0.0.0.0:3024
  public_addr: 192.168.64.2:3080
```

To create the nodes you must first implement the cluster, and log in with the defined user.
- Teleport server on
```
sudo systemctl start teleport
```

Then, type the command:
```
sudo tctl nodes add
```
The necessary keys will be created to make the ssh connection through teleport.
## Node configuration
```
version: v2
teleport:
  nodename: secondarye
  data_dir: /var/lib/teleport
  auth_token: auth_token_key
  auth_servers:
    -  192.168.64.2:3025
  log:
    output: stderr
    severity: INFO
    format:
      output: text
  ca_pin: ca_pin_key
  advertise_ip: 192.168.64.4
auth_service:
  enabled: "no"
ssh_service:
  enabled: "yes"
proxy_service:
  enabled: "no”
```

## Preview
![image](https://user-images.githubusercontent.com/20120875/165180819-2180dc8b-db65-49f7-b948-9458655f4f33.png)

Created by 🐸
