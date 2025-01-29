variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "ec2_security_group_id" {
  description = "EC2 security group ID"
  type        = string
}

variable "engine_version" {
  description = "Aurora engine version"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "master_username" {
  description = "Master username"
  type        = string
}

variable "master_password" {
  description = "Master password"
  type        = string
}

variable "instance_class" {
  description = "Instance class"
  type        = string
}