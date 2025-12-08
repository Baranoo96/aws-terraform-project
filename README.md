# Capstone – WordPress hosting on EC2 with RDS (Multi-AZ) using Terraform
This project deploys a WordPress environment on AWS using Terraform.
The setup includes a public-facing EC2 instance running WordPress and a Multi-AZ RDS MySQL database hosted in private subnets.

🏗️ Architecture Overview
Networking

VPC with one public and two private subnets

Internet Gateway attached for outbound traffic from the public subnet

Route tables configured for proper routing

Private subnets have no direct internet access

Architecture follows standard public/private separation for web and database components

Compute: EC2 WordPress Server

Runs Apache, PHP, and WordPress

Installed automatically using a User Data script

Located in the public subnet

Receives HTTP (port 80) traffic from the internet

Security Group:

HTTP (80) from anywhere

SSH (22) restricted to my IP

Database: RDS MySQL (Multi-AZ)

Deployed across two Availability Zones

Hosted in private subnets

Not publicly accessible

Security Group:

Allows MySQL (3306) only from the EC2 security group

Multi-AZ provides standby failover capability

🧰 Terraform Setup
Main Resources

aws_vpc, aws_subnet, aws_internet_gateway, aws_route_table

aws_security_group for web and database access control

aws_instance for EC2 WordPress

aws_db_instance for RDS MySQL (Multi-AZ enabled)

Terraform Workflow
terraform init        # Download AWS provider + initialize backend
terraform validate    # Validate configuration
terraform plan        # Preview infrastructure changes
terraform apply       # Deploy infrastructure
terraform destroy     # Tear down environment

Terraform Outputs

EC2 Public IP

EC2 Public DNS

RDS Endpoint

These outputs simplify connecting to the server and configuring WordPress.

🔐 Security

Database isolated in private subnets

EC2 only exposes necessary ports (80 + restricted 22)

No public access to RDS

Least privilege applied through Security Groups

📊 Monitoring

A CloudWatch alarm monitors EC2 CPU utilization:

Threshold: CPU > 80% for 5 minutes

Supports basic observability and performance awareness

📦 Architecture Diagram
                     ┌──────────────────────────┐
                     │         Internet         │
                     └──────────────┬───────────┘
                                    │
                             HTTP / Port 80
                                    │
                    ┌───────────────▼────────────────┐
                    │         Public Subnet           │
                    │         10.0.1.0/24             │
                    │   EC2 Instance (WordPress)      │
                    │   - Apache/PHP                  │
                    │   - Public IP                   │
                    └───────────────┬────────────────┘
                                    │
                              MySQL / 3306
                                    │
       ┌────────────────────────────┴────────────────────────────┐
       │                                                         │
┌──────▼──────────────┐                               ┌──────────▼──────────────┐
│ Private Subnet A     │                               │ Private Subnet B       │
│      10.0.2.0/24     │                               │      10.0.3.0/24       │
│ RDS Primary          │                               │ RDS Standby (Multi-AZ) │
│ - No Public Access   │                               │ - Automatic Failover   │
└──────────────────────┘                               └─────────────────────────┘
