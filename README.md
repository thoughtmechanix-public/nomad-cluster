# Building a Nomad/Consul/Krakend lab environment

I wanted to build a multi-node cluster to learn some of the basics of Nomad and Consul.  I came across this blog [post](https://discoposse.com/2019/11/21/building-a-hashicorp-nomad-cluster-lab-using-vagrant-and-virtualbox/) and its corresponding github [repo](https://github.com/discoposse/nomad-vagrant-lab). I downloaded the repo and played around with the configuration.  The guys over at a [Discoposse](https://discoposse.com) did a great job with both the article and the github repo.  

However, the environment did not actually deploy a service. I took their three-node cluster example and extended it with a couple of additional things. In the course of playing with the lab and building out some services I extended the original examples from Discoposse.

1. **Included an example REST based service (written in GoLang) that could be deployed to the Nomad server. I used Packer to build the Docker image for this service**.  This simple service allowed me the opportunity to kick the tires on how to deploy the Docker-based service to the Nomad cluster.

2. **Installed Kraken to act as an API Gateway into the cluster.** An API Gateway is one of the core patterns in building out a micro-service environment and I thought Kraken fit the bill nicely.

3. **Installed DNSMasq on all the servers and forwarded all DNS requests to the consul servers running on the local nodes.** I did this to make it easier to forward requests coming into Krakend and also using curl locally on each node because I could just reference the service by the its FQN domain name inside the node.

4. **Rewrote the shells scripts to provision the nodes into Ansible.**  I use Ansible regularly at my current job and find it much more flexibile in the long run for provisioning environments.

**NOTE:** I do not claim to be an expert in all of these technologies and used this project to kick the tires on a technical stack I dont often get to play with.  

### Pluralsight course - Getting Started with HashiCorp Nomad:  https://app.pluralsight.com/library/courses/hashicorp-nomad-getting-started/table-of-contents

## Pre-requisites

This is the software I used to build this cluster.

1. Vagrant 2.2.14 
2. VirtualBox 6.1
3. Ansible 2.10.8
4. Nomad 1.1.2
6. Packer 1.7.3
7. Golang 1.16.5

## Provisioning the cluster

A simple 3-node or 6-node lab running Ubuntu servers on VirtualBox and each node runs Consul and Nomad servers which can be configured as a cluster.

## Building the Service

## Deploying the Service

## Testing the Server

This is a great way to get your feet wet with Nomad in a simplified environment and you also have a chance to mess around with the configurations and commands without risking a cloud (read: money) installation or a production (read: danger!) environment.

## Requirements

There are a few things you need to get this going:

* Vagrant

* VirtualBox

## How to use the Nomad lab configuration

### For 3-node clusters you must rename `Vagrantfile.3node` to `Vagrantfile`
### For 6-node (two region) clusters you must rename `Vagrantfile.6node` to `Vagrantfile`

* Clone this repo (or fork it of you so desire and want to contribute to it)

* Change directory and run a `vagrant status` to check the dependencies are met

* Run a `vagrant up` command and watch the magic happen! (spoiler alert: it's not magic, it's technology)

* Each node will able to run Consul and Nomad 

To start your Nomad cluster just do this: 

* Connect to the first node (either nomad-a-1 or nomad-b-1) using the `vagrant up` using `vagrant ssh <nodename>` where `<nodename>` is the instance name (e.g. nomad-a-1, nomad-b-1).
* Change directory to the /vagrant folder using `cd /vagrant`
* Launch Nomad using the shell script which is `sudo <nodename>.sh` where `<nodename>` is the node you are running on (e.g. `sudo launch-a-1.sh`)
* Connect to the remaining two nodes (nomad-a-2, nomad-a-3) and repeat the process of changing to the /vagrant folder and running the appropriate launch script

The first node in each of the set of three will begin as the leader.  The other two node launch scripts have a `nomad server join` command to join the cluster with the first node.  

Once you're used to the commmands, you can start and stop as much as needed.  

Consul is installed but not used for the basic configuration.  More to come on that.

Now you're running!

## Interacting with the Nomad and Consul cluster

Logging into the systems locally can be done 

* You can use some simple commands to get started 
```
nomad node status
```
* To open the Nomad UI use this command on your local machine
```
open http://172.16.1.101:4646
```

