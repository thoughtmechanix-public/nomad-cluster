# Building a Nomad/Consul/Krakend lab environment

I wanted to build a multi-node cluster to learn some of the basics of Nomad and Consul.  I came across this blog [post](https://discoposse.com/2019/11/21/building-a-hashicorp-nomad-cluster-lab-using-vagrant-and-virtualbox/) and its corresponding github [repo](https://github.com/discoposse/nomad-vagrant-lab). I downloaded the repo and played around with the configuration.  The guys over at a [Discoposse](https://discoposse.com) did a great job with both the article and the github repo.  

However, the environment did not actually deploy a service. I took their three-node cluster example and extended it with a couple of additional things. In the course of playing with the lab and building out some services I extended the original examples from Discoposse.

1. **Included an example REST based service (written in GoLang) that could be deployed to the Nomad server. I used Packer to build the Docker image for this service**.  This simple service allowed me the opportunity to kick the tires on how to deploy the Docker-based service to the Nomad cluster.

2. **Installed Kraken to act as an API Gateway into the cluster.** An API Gateway is one of the core patterns in building out a micro-service environment and I thought Kraken fit the bill nicely.

3. **Installed DNSMasq on all the servers and forwarded all DNS requests to the consul servers running on the local nodes.** I did this to make it easier to forward requests coming into Krakend and also using curl locally on each node because I could just reference the service by the its FQN domain name inside the node.

4. **Rewrote the shells scripts to provision the nodes into Ansible.**  I use Ansible regularly at my current job and find it much more flexibile in the long run for provisioning environments.

**NOTE:** I do not claim to be an expert in all of these technologies and used this project to kick the tires on a technical stack I dont often get to play with.  


## Pre-requisites

This is the software I used to build this cluster.

1. Vagrant 2.2.14 
2. VirtualBox 6.1
3. Ansible 2.10.8
4. Nomad 1.1.2
6. Packer 1.7.3
7. Golang 1.16.5

## Provisioning the cluster

The first step in the process is to build the nomad and kraken API gateway server virtual machines. To do this simply change to the root directory of project and type `vagrant up`. This will start four virtual servers called:

1. nomad-a-1
2. nomad-a-2
3. nomad-a-3
4. api-gateway

The provisioning process will install all of the necessary software.  The nomad instances will include nomad, consul, docker and dnsmasq.  The api-gateway server has consult, api-gateway and dnsmasq.

The `nomad-a-1` server will expose the following ports:

1. **4646**. Open port for the nomad UI.  Once all of the servers are up and running you should be able to open a web browser from the host machine at http://localhost:4646 to bring up the nomad ui.

2. **8500**. Open port for the consul UI.  Once all of the servers are up and running you should be able to open a web from the host machine at http://localhost:8500 to bring up the consul UI. 

**NOTE:** All servers are running on a private network that is accessible on the host server running the Virtualbox VMs.  The nomad servers are numbered 172.16.1.101, 102, and 103. The API gateway is running on 172.16.1.45.  In addition, the API-gateway does try to retrieve a public IP from your DHCP server.  This is harded code in the Vagrantfile to `wlp0s20f3` network interface.  This could be different on your own machine.  If you do not have a `wlp0s20f3` network interface Vagrant will prompt you during the provisioning of the api-gateway to select an interface.  Select the interface you want to use and then modify the Vagrantfile to use that interface.


## Building the Service

For this project I included a small example microservice to test whether or not the nomad and consul clusters were working properly. The microservice is written in Golang. To build it you need to take two steps:

1. **Compile the service**. Change to the `services/orders` directory and run `make build`.  This will build the binary.  Since I deploy everything to linux I am setting the `GOOS` environment to `linux`.

2. **Build the docker binary**.  To deploy to our Nomad cluster we need to build and deploy our service using a container or virtual machine. To accomplish this, I pack up our example service using a `docker`.  The `docker` container is built using Hashicorp's `packer` tool.  To build the container change to the `services/orders/provision` directory and issue the following command:

```shell
packer build -var "docker_username=*****" -var "docker_password=*****" -var "docker_repo=*****" orders.pkr.hcl
``` 

You will need to provide your docker hub credentials (`docker_username` and `docker_password`) and the docker repository (`docker_repo`) you want to push the docker container. The docker repository is where we will pull the docker image from when we later deploy the service using nomad.

For more detailed explanation of how to build a service using `packer`, checkout on this [blog post](https://thoughtmechanix.com/posts/8.01.2021_packer/).

## Deploying the Service

All deploys to our nomad cluster are done using the nomad CLI installed locally. After you have built the above service, change to the `deploy/` directory, and run the `nomad run orders.nomad` command. Nomad will then deploy the service to all three of the nomad instances.  

## Testing the Server and services have deployed

Once the `order` service has been deployed you can check to see if it has deployed successfully via 2 mechanisms.

1. **Hit the healthcheck for the orders services.** The order service's healthcheck endpoint is exposed publicly through the krakend API gateway. To see if the service is deployed appropriately you can curl from the command line with the following command-line: `curl http://localhost:8080/v1/orders/healthcheck`.  You will see a JSON payload that looks like this: `{"Message":"Everything is going to be all right","StatusCode":200}`

2. **Check the nomad UI**. You can access the nomad UI and see the three instances of the services deployed [here](http://localhost:8500/ui/cary/services/orders/instances).

3. **Check the consul UI**. You can access the consul UI and see the orders service deployed across all three consul nodes. The endpoint to access this is [here](http://localhost:4646/ui/jobs/orders-job).

**NOTE:** The orders service healthcheck is only accessible from the Krakend API gateway. The mapping of the service endpoint to the deployed Nomad services can be found in `ansible/playbooks/krakend/files/orders-krakend.json` file.

## Conclusion

The goal of this README was not to provide a README of how all of the pieces of how a Nomad cluster running consul works. Instead, I wanted to provide you with enough information to get the cluster up and running so you could see for yourself and the have a working playground to deploy your own services.  Nothing speaks more truth then actual working code. If you find any misinformation or inaccurate information in these instructions please do not hesitate to open an issue in the repository.



