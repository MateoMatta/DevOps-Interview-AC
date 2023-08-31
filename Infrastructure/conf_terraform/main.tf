terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-resources-test"
    key    = "tfstates"
    region = "us-east-1"
  }

}

provider "aws" {
  region = "us-east-1"
  
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name   = "Particular VPC"
    Author = "Mateo Matta"
  }
}

resource "aws_subnet" "demo-sub-01" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name   = "Particular subnet for us-east-1"
    Author = "Mateo Matta"
  }
}

resource "aws_internet_gateway" "ig-demo" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name   = "Principal Internet Gateway"
    Author = "Mateo Matta"
  }

}

resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-demo.id
  }

  tags = {
    Name = "demo-rtb"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.demo-sub-01.id
  route_table_id = aws_route_table.demo_route_table.id
}

resource "aws_security_group" "demo-sg-01" {
  name        = "allow_ssh_and_web_server_ports"
  description = "Allow SSH and web ports for inbound traffic"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Web server port from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH connection from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #   ingress {
  #   description      = "Personal connecction from VPC to have a pre-work for the website"
  #   from_port        = 0
  #   to_port          = 0
  #   protocol         = "-1"
  #   cidr_blocks      = ["181.xxx.xxx.xxx/32"]
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }



  tags = {
    Name   = "allow_ssh_and_web_ports"
    Author = "Mateo Matta"
  }
}

# resource "aws_instance" "my_vm" {
#   ami             = "ami-0261755bbcb8c4a84" //Ubuntu AMI
#   instance_type   = "t2.micro"
#   key_name        = "candidate"

#   tags = {
#     Name = "My EC2 instance"
#     Author = "Mateo Matta"
#   }
# }
# name = "demo-elb"
# subnets = [aws_subnet.demo-sub-01.id]
# security_groups = [aws_security_group.demo-sg-01.id]

resource "aws_autoscaling_group" "demo_autoscaling" {
  name                 = "demo-asg-instance-1"
  min_size             = "1"
  max_size             = "2"
  desired_capacity     = "2"
  vpc_zone_identifier  = [aws_subnet.demo-sub-01.id]
  launch_configuration = aws_launch_configuration.demo_configuration.name
  load_balancers       = [aws_elb.demo-elb.name]
  tag {
    key                 = "Name"
    value               = "demo-asg-instance-1"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "demo_configuration" {
  name                        = "placeholder-demo-lc"
  image_id                    = "ami-0261755bbcb8c4a84"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.demo-sg-01.id]
  associate_public_ip_address = true
  key_name                    = "candidate"
  user_data                   = file("../scripts/ansibleLaunchConfiguration.sh")
  #export keys
}

resource "aws_elb" "demo-elb" {
  name            = "demo-elb-elb"
  subnets         = [aws_subnet.demo-sub-01.id]
  security_groups = [aws_security_group.demo-sg-01.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

}
resource "aws_s3_bucket" "s3Bucket" {
  bucket = "terraform-resources-test"
  lifecycle {
    create_before_destroy = true
  }
  # acl = "public-read"

  }

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.s3Bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
    statement {
    principals {
      type        = "AWS"
      identifiers = ["729158664723"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.s3Bucket.arn,
      "${aws_s3_bucket.s3Bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_versioning" "versioning_for_s3Bucket" {
  bucket = aws_s3_bucket.s3Bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_security_group" "postgres_db_demo" {
  vpc_id      = aws_vpc.demo-vpc.id
  name        = "postgres_db_demo"
  description = "Allow all inbound for Postgres"
ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "default" {
  identifier             = "postgres-db-demo-mateo"
  db_name                = "postgres_db_demo"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "12.5"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.postgres_db_demo.id]
  username               = "mateo"
  password               = random_password.password.result
}


module "rds_example_complete-postgres" {
  source  = "terraform-aws-modules/rds/aws//examples/complete-postgres"
  version = "6.1.1"
}
# resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#   bucket = aws_s3_bucket.s3Bucket.id
#   policy = data.aws_iam_policy_document.allow_access_from_another_account.json
# }

# data "aws_iam_policy_document" "allow_access_from_another_account" {
#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = ["729158664723"]
#     }

#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#     ]

#     resources = [
#       aws_s3_bucket.s3Bucket.arn,
#       "${aws_s3_bucket.s3Bucket.arn}/*",
#     ]
#   }
# }

# acl    = "public-read"

#     policy = <<EOF
# {
#      "id" : "MakePublic",
#    "version" : "2012-10-17",
#    "statement" : [
#       {
#          "action" : [
#              "s3:GetObject"
#           ],
#          "effect" : "Allow",
#          "resource" : "arn:aws:s3:::terraform-resources-test/*",
#          "principal" : "*"
#       }
#     ]
#   }
# EOF

# website {
#   index_document = "index.html"
# }
# }

#     #   #   listener {
#     #   #   instance_port      = 80
#     #   #   instance_protocol  = "http"
#     #   #   lb_port            = 443
#     #   #   lb_protocol        = "https"
#     #   #   ssl_certificate_id = "arn:aws:iam::016311465375:test-certificate/mateomatta"
#     #   # }


