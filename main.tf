data "terraform_remote_state" "site"{
    backend =  "s3" 
    config = {
    bucket = "matanelstateterraform"
    key = "workshop-site-state/terraform.tfstate"
    dynamodb_table = "tf-workshop-site-locks"
    region = "us-east-1"
  }
}
resource "aws_key_pair" "admin_key" {
key_name = "${var.environment}-key"
public_key = "${file("${path.module}/keys/admin.pub")}"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  tags = { Name = "${var.environment}-vpc"}
}

resource "aws_autoscaling_group" "workshop-app_asg" {
  name = "asg"
  launch_configuration = "${aws_launch_configuration.workshop-app_lb.name}"
  max_size = (2)
  min_size = (0)
  desired_capacity = (1)
  # availability_zones = ["us-east-1a"]
  vpc_zone_identifier  = ["${aws_subnet.public[0].id}"]
  load_balancers = ["${var.cluster_name}lb"]
  # vpc_zone_identifier = element(data.terraform_remote_state.site.outputs.public_subnets[0].id)
 
 

  tag {
    key = "Name"
    value = "chef"
    propagate_at_launch = true
  }
tag {
  key = "protected"
  value = "yes"
  propagate_at_launch = true
}
  tag {
    key = "Team"
    value = "Workshop"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

 resource "aws_launch_configuration" "aws_lc" {
   name_prefix   = "terraform-lc-example-"
   image_id      =  "ami-0b75998a97c952252"
   instance_type = "t2.micro"

   lifecycle {
     create_before_destroy = true
   }
 }

resource "aws_launch_configuration" "workshop-app_lb" {
    user_data =  "${file("workshop-app/templates/project-app.cloudinit")}"
   lifecycle {  # This is necessary to make terraform launch configurations work with autoscaling groups
    create_before_destroy = true
  }
  security_groups = [aws_security_group.workshop-app_lb.id]
  name_prefix = "${var.cluster_name}_lb"
  enable_monitoring = false

  image_id = var.ami
  instance_type = var.instance_type
  key_name = "itamarkeypair"
  

  //??? complete the missing attribute
}  

resource "aws_security_group" "workshop-app_lb" {
 
  name = "${var.cluster_name}-lb"
  description = "${var.cluster_name}-lb"
  vpc_id = aws_vpc.vpc.id
  # region = "us-east-1"
  #  azs  =  "us-east-1b, us-east-1a"



  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



 resource "aws_elb" "workshop-app" {
   name = "${var.cluster_name}lb"
  #  availability_zones = ["us-east-1a"]
   subnets  = ["${aws_subnet.private[0].id}", "${aws_subnet.public[0].id}"]

  #  subnets = element(data.terraform_remote_state.site.outputs.public_subnets, 0)
   security_groups = [ aws_security_group.workshop-app_lb.id ]
   listener {
     instance_port     = 80
     instance_protocol = "http"
     lb_port           = 80 
     lb_protocol       = "http"
  }
 }
#  resource "aws_autoscaling_group" "workshop-app_asg2" {
#    name = "${var.cluster_name}_asg"
#    launch_configuration = "${aws_launch_configuration.workshop-app_lb.name}"
#    max_size = (3)
#    min_size = (2)
#    desired_capacity = (2)
#   #  availability_zones = ["us-east-1a"]
#    vpc_zone_identifier  = ["subnet-00936cba635888d57"]
#   #  vpc_zone_identifier = element(data.terraform_remote_state.site.outputs.public_subnets, 0)
 

#    tag {
#      key = "Name"
#      value = var.cluster_name
#      propagate_at_launch = true
#     }

#    tag {
#      key = "Team"
#      value = "Workshop"
#      propagate_at_launch = true
#    }

#    lifecycle {
#      create_before_destroy = true
#    } 
# }