# root/terraform.tfvars
environment         = "prod"
aws_region          = "us-east-1"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
availability_zone   = "us-east-1a"
ami_id              = "ami-04552bb4f4dd38925" # Ubuntu 22.04 LTS
instance_type       = "t2.micro"
key_name            = "ec2-key"
docker_image        = "nginx:latest"
docker_port         = 80

# RDS Configuration
engine_version  = "5.7.mysql_aurora.2.10.2"
database_name   = "mydb"
master_username = "admin"
master_password = "YourStrongPasswordHere123!" # Change this
instance_class  = "db.t3.medium"

# Load Balancer and Domain Configuration
certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/your-certificate-id" # Replace with your cert ARN
domain_name     = "your-domain.com"                                                    # Replace with your domain
hosted_zone_id  = "Z1234567890ABC"                                                     # Replace with your hosted zone ID
