variable "AWS_REGION" {
  default = "us-east-1"
}

# AMI will be for the bastion host in the public subnet of the VPC
# for project26 convert the bastion host ubuntu to CIS hardened ubuntu
variable "AMIS" {
  type = map(any)
  default = {
    #us-east-1 = "ami-051f8a213df8bc089"
    # this is from the first_instance.tf file. This is amazon linux

    #update us-east-1 with ubuntu 20 image for project16 bastion host
    #us-east-1 = "ami-0cd59ecaf368e5ccf"

    #update us-east-1 with CIS ubuntu 20 for project26 bastion host
    us-east-1 = "ami-0ea252761070f6801"


    #us-east-2 = "ami-0900fe555666598a2"
    # get this sample ami from us-east-2; same operating system and version. This is amazon linux in region us-east-2

    #us-east-2 CIS ubuntu 20 for project 26 bastion host
    us-east-2 = "ami-00b75dccbcff4b908"

    #us-west-1 CIS ubuntu 20
    us-west-1 = "ami-0261a92acdb3905d9"

    #us-west-2 CIS ubuntu 20
    us-west-2 = "ami-0438cdcd81cd319be"
  }
}




# use the private and public key from previous exercises
variable "PUB_KEY_PATH" {
  default = "vprofile-keypair-terraform-project16.pub"
}

variable "PRIV_KEY_PATH" {
  default = "vprofile-keypair-terraform-project16"
}




variable "USERNAME" {
  #default = "ec2-user"
  # this is an amazon linux EC2 instance and not ubuntu
  default = "ubuntu"
  # this is the default user for ubuntu instance
  # leave this at default for the ubuntu bastion host that will use this variable.
}


variable "my_ip" {
  default = "73.202.0.0/16"
}


# we will use AWS RabbitMQ
variable "rmquser" {
  default = "rabbit"
}

# password must be more than 12 characters
variable "rmqpass" {
  default = "twelvecharacters"
}

# RDS credentials
variable "dbuser" {
  default = "admin"
}

variable "dbpass" {
  default = "admin123"
}

variable "dbname" {
  default = "accounts"
}




variable "instance_count" {
  default = "1"
}




variable "VPC_NAME" {
  default = "vprofile-project16-VPC"
}

variable "VpcCIDR" {
  default = "172.21.0.0/16"
}

variable "PubSub1CIDR" {
  default = "172.21.1.0/24"
}

variable "PubSub2CIDR" {
  default = "172.21.2.0/24"
}

variable "PubSub3CIDR" {
  default = "172.21.3.0/24"
}

variable "PrivSub1CIDR" {
  default = "172.21.4.0/24"
}

variable "PrivSub2CIDR" {
  default = "172.21.5.0/24"
}

variable "PrivSub3CIDR" {
  default = "172.21.6.0/24"
}


variable "ZONE1" {
  default = "us-east-1a"
}

variable "ZONE2" {
  default = "us-east-1b"
}

variable "ZONE3" {
  default = "us-east-1c"
}






# variable vpc_id {
#     default = "vpc-project15-excercise6"
# }
