 variable  "environment"  {
   description = "This is mainly used to set various ideintifiers and prefixes/suffixes"
 }

variable "private_subnets" {
  description = "IP prefix of private (vpc only routing) subnets"
}

variable "public_subnets" {
  description = "IP prefix of public (internet gw route) subnet"
}

variable "region" {
  type = string
}

variable "azs" { }

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default = true
}
variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default = true
}

variable "vpc_cidr" {
  type =  string
    description = "IP prefix of main vpc"
}
variable "cluster_name" {
  type = string
  default = "mycluster"
  
}

variable "instance_type" {
  description = "instance type for workshop-app instances"
  default = "t2.micro"
}

variable "ami" {
  description = "ami id for workshop-app instances"
  default = "ami-0817d428a6fb68645"
}

variable "cluster_name_asg" {
	default = "workshop-terraform"
}


variable "site_module_state_path" {
  default = "workshop-site-state/terraform.tfstate"
  description = <<EOS
S3 path to the remote state of the site module.
The site module is a required dependency of this module
EOS

}

variable "terraform_bucket" {
  default = "workshop-tf-state"
  description = <<EOS
S3 bucket with the remote state of the site module.
The site module is a required dependency of this module
EOS

}

# variable web-app {
# sudo apt-get update
# sudo apt-get install -y apache2
# sudo systemctl start apache2
# sudo systemctl enable apache2
# echo "<h1>Deployed via Terraform</h1>"  sudo tee /var/www/html/index.html
  
# } 

