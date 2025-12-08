Capstone Project – WordPress Hosting on AWS using Terraform

This project deploys a small production-style WordPress environment on AWS using Terraform as Infrastructure as Code (IaC).

The setup includes:

EC2 instance running WordPress in a public subnet

RDS MySQL database in private subnets with Multi-AZ enabled

Strict Security Groups for controlled communication

Fully automated provisioning with Terraform

⭐ 1. Architecture Overview
The environment follows a secure 3-layer structure:

🔹 Network Layer

VPC with public & private subnets
Internet Gateway for EC2 access
Route tables for traffic flow
Security Groups instead of ACLs (least privilege)

🔹 Compute Layer (EC2 + WordPress)
EC2 instance in public subnet
Apache + PHP installed via User Data
Security Group allows:
HTTP (80) from anywhere
SSH (22) only from my IP
EC2 connects internally to RDS

🔹 Database Layer (RDS MySQL Multi-AZ)

Runs in private subnets

No public access

Automatic failover via Multi-AZ standby

Only accessible from EC2's security group on port 3306

🧱 2. Architecture Diagram
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

🚀 3. Terraform Deployment

The environment is deployed using the standard Terraform workflow:

terraform init       # Download AWS provider, initialize project
terraform validate   # Validate .tf files
terraform plan       # Preview changes
terraform apply      # Deploy infrastructure
terraform destroy    # Tear down infrastructure

Terraform creates:

VPC, Subnets, Route Tables

Internet Gateway

EC2 Instance + IAM role

RDS MySQL (Multi-AZ)

Security Groups

Outputs (Public IP, DNS, RDS endpoint)

🛡️ 4. Security Overview
✔ Private database — not reachable from the internet
✔ EC2 exposes only minimal ports

80 (HTTP)

22 (restricted to your IP)

✔ RDS access locked to EC2 security group

No external clients can reach MySQL.

✔ Principle of Least Privilege

Each component only gets the permissions it needs.

📊 5. Monitoring

A CloudWatch alarm tracks CPU usage of the EC2 instance:

Trigger: CPU > 80%

Evaluation period: 5 minutes

Helps identify load issues or attacks

(No SNS notifications configured, as not needed for the demo.)

📤 6. Terraform Outputs

Terraform provides useful values after deployment:

EC2 Public IP

EC2 Public DNS

RDS Endpoint

These outputs simplify WordPress setup and verification.
