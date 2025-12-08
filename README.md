Capstone Project – WordPress Hosting on AWS using Terraform

This project deploys a small production-style WordPress environment on AWS using Terraform as Infrastructure as Code (IaC).

The setup includes:

EC2 instance running WordPress in a public subnet

RDS MySQL database in private subnets with Multi-AZ enabled

Strict Security Groups for controlled communication

Fully automated provisioning with Terraform

## 1. Architecture Overview

This project uses a three-layer AWS architecture following best practices for security, scalability, and separation of concerns.

### 🔹 Network Layer
- VPC with **one public** and **two private subnets**
- Internet Gateway enabling public access only for the EC2 instance
- Route tables controlling network paths
- Security Groups enforcing least-privilege communication rules

### 🔹 Compute Layer (EC2 + WordPress)
- EC2 instance hosted in the **public subnet**
- WordPress installed via User Data (Apache, PHP, config)
- Security Group rules:
  - HTTP (Port 80) open publicly
  - SSH (Port 22) restricted to my IP
- EC2 communicates with RDS over internal AWS networking

### 🔹 Database Layer (RDS MySQL Multi-AZ)
- RDS deployed in **private subnets only**  
- No public exposure, no direct internet access  
- Multi-AZ enabled → automatic failover to standby instance  
- Only the EC2 Web Security Group may access MySQL on port 3306  

---

## 🧱 Architecture Diagram

```txt
                   Internet
                               │
                         HTTP / Port 80
                               │
                ┌──────────────────────────────────┐
                │          Public Subnet           │
                │             10.0.1.0/24          │
                │  EC2 Instance (WordPress)        │
                │  - Apache/PHP                    │
                │  - Public IP                     │
                └────────────────┬─────────────────┘
                                 │
                           MySQL / 3306
                                 │
        ┌────────────────────────┴────────────────────────┐
        │                                                 │
  ┌───────────────┐                                   ┌────────────────┐
│ Private Subnet A │                                 │ Private Subnet B │
│   10.0.2.0/24    │                                 │   10.0.3.0/24    │
│   RDS Primary    │                                 │   RDS Standby    │
│ - No Public Access │                               │ - Multi-AZ       │
└──────────────────┘                                 └──────────────────┘
```

🚀 3. Terraform Deployment
````
The environment is deployed using the standard Terraform workflow:

terraform init       # Download AWS provider, initialize project
terraform validate   # Validate .tf files
terraform plan       # Preview changes
terraform apply      # Deploy infrastructure
terraform destroy    # destroy infrastructure
````
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

22 (restricted to my IP)

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
