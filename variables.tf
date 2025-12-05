variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Names for tags"
  type        = string
  default     = "capstone-level1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "Existing EC2 Key Pairs for SSH (in us-west-2!)"
  type        = string
}

variable "my_ip_cidr" {
  description = "Public Ip as CIDR For SSH "
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_name" {
  description = "Name of Wordpress RDS"
  type        = string
  default     = "wordpress"
}

variable "db_username" {
  description = "DB-Username for RDS"
  type        = string
  default     = "wpuser"
}

variable "db_password" {
  description = "DB-Password for RDS"
  type        = string
  default     = "WpPass123!"
}
