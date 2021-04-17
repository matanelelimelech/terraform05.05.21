
// define an s3 backend here
terraform {
  backend "s3" {
    bucket = "matanelstateterraform"
    key = "workshop-site-state/terraform.tfstate"
    dynamodb_table = "tf-workshop-site-locks"
    region = "us-east-1"
  }
}


provider "aws" {
   region = "us-east-1"
 }
# module  "workshop-app_lb" {
#   source = "../"
#   region = "us-east-1"
#   azs  =  "us-east-1b, us-east-1a"
#   vpc_cidr =  "172.18.0.0/18"
#   private_subnets = "172.18.0.0/19"  
#   public_subnets  = "172.18.32.0/19"
#   environment = "workshop-production"  
# }
module "vpc" {
  source = "../"
  environment = "workshop-production"
  region = "us-east-1"
  vpc_cidr =  "172.18.0.0/18"
  private_subnets = "172.18.0.0/19"  
  public_subnets  = "172.18.32.0/19"  
  //fill 2 availability zones associated with the region
  azs  =  "us-east-1b, us-east-1a"
  enable_dns_support = true
  enable_dns_hostnames = true
  # aws_launch_configuration = "aws_lc"
}


module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"
  #  name = "workshop-app"
  #  subnets         = ["subnet-0847a3da5e43a0fe6"]
  #  security_groups = ["sg-0de05d80d580ac00b"]
  # subnets = element(data.terraform_remote_state.site.outputs.public_subnets, 0)
  # security_groups = [ aws_security_group.workshop-app_lb.id ]
#   internal        = false

#   listener = [
#     {
#       instance_port     = 80
#       instance_protocol = "HTTP"
#       lb_port           = 80
#       lb_protocol       = "HTTP"
#     }

# ]
# health_check = {
#     target              = "HTTP:80/"
#     interval            = 30
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 5
#   }
 }

# #  module "aws_launch_configuration"{
# #  aws_launch_configuration = "aws_lc"
  


output "environment" {value = [module.vpc.environment]}

output "vpc_cidr" {value = [module.vpc.vpc_cidr]}

output "admin_key_name" {value = [module.vpc.admin_key_name]}

output "private_subnets" {value = [module.vpc.private_subnets]}


output "public_subnets" {value = [module.vpc.public_subnets]}

output "vpc_id" {value = [module.vpc.vpc_id]}

# output "workshop-app_lc" {value = [module.workshop-app_lc.aws_launch_configuration] }
  

  

# output "workshop-app" {value = [module.vpc.aws_elb] }
  