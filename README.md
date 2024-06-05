# Project 26: Securitizing and hardening the terraform VPC and the full stack vprofile deployment

## Bastion host

Harden the bastion host with an CIS ubuntu image.  Modify the bastion host amis in the vars.tf accordingly
The CIS ubuntu image will not allow a remote-exec terraform provisioner block to be executed on the bastion host to configure the RDS mysql database schema.  For now remove the block from bastion-host.tf and after the terraaform infra is up, SSH into the bastion host and copy the db-deploy.tmpl from /tmp to /home/ubuntu and chmod +x the file and then manually execute it on the bastion host. This will configure the schema on the RDS mysql server.

## Security groups

The security groups are much the same as the nonsecuritized setup.  Can allow SSH from MyIP only but other than that the security groups are the same.

## Optionally encrypt the EBS volumes with the KMS key

## Elastic Beanstalk loadbalancer: migrate from HTTP to HTTPS

The certificate is created in ACM and can be applied to the loadbalancer listener.   Currently running on port 80 for HTTP and 443 for HTTTPs. This provides encryption for data in transit to the application website.  When creating the 443 listener, make sure instance port is 80 and HTTP.

## Modify the application.properties in the vprofile application source code local repository and rebuild the source code artifact .war file

Based upon the current terraform deployment get the endponts for the RDS, memcached and rabbitmq servers and update the application.properties file accordingly.

In the local source git repository rebuild the source code artifact with mvn install.
The target folder will have the updated artifact.


## Deploy the new artifact to the running Elastic Beanstalk environment application

Upload the new .war file to the running elastic beanstalk instance.  Once the deployment is complete, the healthchecks on the loadbalancer will fail. This is because the content is now running on HTTP port 8080 and 
/login URL. Update the elastic beanstalk listener accordingly and also update the loadbalancer healthchecks accordingly.  The healthcheck of the loadbalancer should go to in-service and eventually the beanstalk environment will switch to healthy state.  At this point the full application stack on HTTPS should be working.

## Deploying the NACLs

The NACLs can be added after the upload. The current NACL rules are blocking the upload and need to figure out what addtional rules are required to allow the upload to beanstalk applcation server (tomcat) to occur. 


The NACLs have to allow SSH, 443, (80), and traffic from the VPC CIDR block to all, on inbound public subnet.  The VPC to all is required for the healthchecks to remain up.   The outbound NACL should allow all to anywhere for the public subnet.

For the private subnet (servers) the inbound rules have to allow traffic from anywhere to all allow (port 80 and/or 8080 is used on the backend).  The outbound NACL for private subnet must allow all to anywhere. The healtcheck returns outbound on the private subnet to inbound on the public subnet (loadbalancer) (see inbound NACL rules abouve for public subnet)









# terraform-aws2-vprofile-full-stack-implementation
Project16: Full stack implementation of vprofile app using terraform IaaC for network infra automation and some of the stack implementation on AWS2

backend-services.tf
backend.tf
beanstalk-app.tf
beanstalk-env.tf
keys_aws.tf
providers.tf
secgrp.tf
var.tf
vpc.tf
bastion-host.tf

backend-services.tf and beanstalk-env.tf form the core of the infra deployment: RDS, elasticache, rabbitmq backend with elastic beanstalk ALB frontend with tomcat server on private address space. Deploy the .war vprofile app onto the tomcat servers, and also intialize the mysql backend db with a bastion host method.

The bastion host method uses local and remote provisioners with a script to provision the mysql RDS server for the project

Once the infra is up and running, for now manually deploy the vprofile.war file. To do this manually rebuild the artifact.war file with maven (mvn install).  To do this must configure the application.properties file with the proper endponts for the RDS, RabbitMQ and Elasticache servers, as well as with the passwords and the proper ports.   The terraform has provisioned the servers with the same passwords as configured in the vars.tf file. In reality we would not commit such code but rather would use terraform.tfvars which is in the .gitignore file and will not be pushed to the repository.  But this is simply a test deployment of a full stack java application.  

The new .war file that is built has the proper passwords and endpoints built into it in application.properties, so this java app installed and pushed to the tomcat servers in the Elastic Beanstalk deployment will be able to establish socket connections to all of the backend servers and function properly.

Note: the vprofile app does not work with mysql 8.0 so had to use 5.7.44 which is still in extended release but is EOL as of Feb/March 2024

For now, the only manual part that has not been automated is the building of the artifact and the deployment of the artifact to the Elastic Beanstalk environment, but this can easily be automated with a github actions or jenkinsfile pipeline or on AWS itself with AWS Build and Code and Artifact/Deploy and Pipeline as in previous projects.

1. terraform apply the IaaC
2. modify the application.properties in source code for the proper endpoints in accordance with latest IaaC deployment in step 1.
3. Rebuild the .war artifact with mvn install
4. Deploy the .war to the beanstalk environment.

A similar project will be done with GitOps with similar terraform IaaS but workflow to docker build and publish and to EKS rather than to Elastic Beanstalk.  Containers are much more easy and clean to deploy than EC2 server instances.  The docker container deployment can be orchestrated via K8s if required with the k8s cluster being setup with kops or kubeadm as in previous projects (project 17 will actually use helm which is a great k8s package manager). There are many solutions to the CI/CD deployment paradigm....




======

% terraform state list
aws_db_instance.vprofile-project16-rds-server
aws_db_subnet_group.vprofile-project16-rds-subgrp
aws_elastic_beanstalk_application.vprofile-project16-elastic-beanstalk-prod-application
aws_elastic_beanstalk_environment.vprofile-project16-bean-prod-env
aws_elasticache_cluster.vprofile-project16-elasticache
aws_elasticache_subnet_group.vprofile-project16-elasticache-subgrp
aws_instance.vprofile-project16-bastion-host[0]
aws_key_pair.vprofile-keypair-terraform-project16
aws_mq_broker.vprofile-project16-rmq
aws_security_group.vprofile-project16-backend-sg
aws_security_group.vprofile-project16-bastion-sg
aws_security_group.vprofile-project16-bean-elb-sg
aws_security_group.vprofile-project16-prod-beanstalk-sg
aws_security_group_rule.sec_group_backend_allow_itself
module.vpc.aws_default_network_acl.this[0]
module.vpc.aws_default_route_table.default[0]
module.vpc.aws_default_security_group.this[0]
module.vpc.aws_eip.nat[0]
module.vpc.aws_internet_gateway.this[0]
module.vpc.aws_nat_gateway.this[0]
module.vpc.aws_route.private_nat_gateway[0]
module.vpc.aws_route.public_internet_gateway[0]
module.vpc.aws_route_table.private[0]
module.vpc.aws_route_table.public[0]
module.vpc.aws_route_table_association.private[0]
module.vpc.aws_route_table_association.private[1]
module.vpc.aws_route_table_association.private[2]
module.vpc.aws_route_table_association.public[0]
module.vpc.aws_route_table_association.public[1]
module.vpc.aws_route_table_association.public[2]
module.vpc.aws_subnet.private[0]
module.vpc.aws_subnet.private[1]
module.vpc.aws_subnet.private[2]
module.vpc.aws_subnet.public[0]
module.vpc.aws_subnet.public[1]
module.vpc.aws_subnet.public[2]
module.vpc.aws_vpc.this[0]
