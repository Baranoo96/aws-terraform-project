# Capstone – WordPress on EC2 with RDS (Multi-AZ) using Terraform

This project deploys a small WordPress environment on AWS using Terraform.

- EC2 instance in a public subnet running WordPress (Apache + PHP)
- RDS MySQL database in private subnets (Multi-AZ)
- Communication between EC2 and RDS restricted through Security Groups
- Entire infrastructure defined as Infrastructure as Code (IaC)

## Architecture (Summary)

- **VPC** with one public and two private subnets  
- **EC2** instance in the public subnet (web server, WordPress)  
- **RDS MySQL (Multi-AZ)** across two private subnets  
- **Security Groups**:
  - Web-SG: allows HTTP (80) from anywhere, SSH only from my IP
  - RDS-SG: allows MySQL (3306) only from Web-SG

## Deployment (Terraform)

```bash
terraform init
terraform validate
terraform plan
terraform apply
                          
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
