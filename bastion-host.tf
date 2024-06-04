# Create an EC2 Bastion host instance
resource "aws_instance" "vprofile-project16-bastion-host" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  # ami will come from lookup in variable "AMIS" in vars.tf file and AWS_REGION default which is us-east-1
  # This is currently set to ubuntu 20 image which is what we want for the bastion host

  key_name = aws_key_pair.vprofile-keypair-terraform-project16.key_name

  subnet_id = module.vpc.public_subnets[0]
  # this will create it in the first public subnet

  associate_public_ip_address = "true"
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance.html#associate_public_ip_address

  count = var.instance_count

  vpc_security_group_ids = [aws_security_group.vprofile-project16-bastion-sg.id]
  # see the secgrp.tf file. This will permit me/terraform to SSH in from the mac PC to the  public interface of bastion host
  # so that we can run the provisioners below (scripts) to provision the mysql RDS server in the private subnet

  tags = {
    Name    = "vprofile-project16-bastion-host"
    PROJECT = "vprofile-project16"
  }


  # push a shell script to bastion host to provision mysql db
  # need endpoint, user and password
  # terraform state has the endpoint. Need to use the terraform templatefile function
  # https://developer.hashicorp.com/terraform/language/functions/templatefile
  # templatefile(path, vars)   vars will be the RDS endpoint
  # template file will be in shell db-deploy.tmpl
  provisioner "file" {
    content     = templatefile("templates/db-deploy.tmpl", { rds-endpoint = aws_db_instance.vprofile-project16-rds-server.address, dbuser = var.dbuser, dbpass = var.dbpass })
    destination = "/tmp/vprofile-dbdeploy.sh"
    # this places the shell script into the /tmp directory on this bastion host with name vprofile-dbdeploy.tmpl
  }



# commentout the remote-exec provisioner for project26 securitized. We will not be able to run this on the CIS ubuntu instance
# Instead copy the vprofile-dbdeploy.sh from /tmp to /home/ubuntu and chmod +x the file and run it from there to configure the 
# RDS mysql database.  This will config the schemo for the accounts account on the RDS instance along with all the users and credentials.
  # provisioner "remote-exec" {
  #   #execute the shell script on this bastion host
  #   inline = [
  #     "chmod +x /tmp/vprofile-dbdeploy.sh",
  #     "sudo /tmp/vprofile-dbdeploy.sh"
  #   ]
  # }

  connection {
    # this will instruct terraform/my pc on how to open the connection to this bastion host so that the above provisioners can be run
    user        = var.USERNAME
    private_key = file(var.PRIV_KEY_PATH)
    # the keys are all on root of this project
    host = self.public_ip
  }

  # bastion host should only happen after backend services (RDS, etc) is up and running The RDS endpoint must be ready
  depends_on = [aws_db_instance.vprofile-project16-rds-server]
}
# end aws_instance bastion resource
