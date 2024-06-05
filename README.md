# Project 26: Securitizing and hardening the terraform VPC and the full stack vprofile deployment



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
