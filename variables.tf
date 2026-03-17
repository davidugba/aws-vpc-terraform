variable "aws_region" {
  description = "AWS region to deploy networking resources"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "aws-vpc"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet in AZ 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet in AZ 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet in AZ 1"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet in AZ 2"
  type        = string
  default     = "10.0.12.0/24"
}

variable "az_1" {
  description = "Primary availability zone"
  type        = string
  default     = "eu-north-1a"
}

variable "az_2" {
  description = "Secondary availability zone"
  type        = string
  default     = "eu-north-1b"
}


variable "ec2_ami_id" {
  description = "AMI ID for private EC2 instance"
  type        = string
  default     = "ami-0c1ac8a41498c1a9c"
}

variable "ec2_instance_type" {
  description = "EC2 instance type for private subnet host"
  type        = string
  default     = "t3.micro"
}