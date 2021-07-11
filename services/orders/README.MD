# Quick Notes

Simple service to demonstrate a couple of Hashicorp capabilities

1.  To build the service change run `make build`
2.  To provision the service cd to the 'provision and run `packer build -var "docker_username=<<DOCKER USERNAME>>" -var "docker_password=<<DOCKER PASSWORD>>" -var "docker_repo=<<DOCKER REPO HERE>>" orders.pkr.hcl`
3.  To run the container `docker run -d -p 8888:8888 <<Container Image here>>`