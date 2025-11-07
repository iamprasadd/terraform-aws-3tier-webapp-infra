🌩️ AWS 2-Tier Architecture Using Terraform
🚀 Overview

This project demonstrates how to build a 2-tier web application architecture on AWS using Terraform, implementing Infrastructure as Code (IaC) principles to create reusable, scalable, and secure infrastructure.

The architecture includes:

Web Tier: EC2 instances running web servers, managed by an Application Load Balancer (ALB) and Auto Scaling Group.

Database Tier: EC2 instances hosting a primary and replica database for high availability.

Networking: Secure and scalable VPC setup with public/private subnets, NAT gateways, and appropriate security groups.

🏗️ Architecture Diagram

![alt text](.images/2tier-web-application-architecture.png)

🧱 Key Components
Layer	Components	Description
Networking	VPC, Public & Private Subnets, NAT Gateways	Provides network isolation and secure routing
Web Tier	ALB, Auto Scaling Group, EC2 Instances	Hosts the web application and handles incoming traffic
Database Tier	EC2 (Primary + Replica)	Stores application data with replication for high availability
Security	Security Groups, IAM Roles	Controls inbound/outbound traffic and permissions
State Management	Terraform S3 Backend, DynamoDB	Stores Terraform state remotely and enables state locking
⚙️ Folder Structure
terraform-2tier/
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tf
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── alb/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── rds/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

💡 Step-by-Step Implementation
1. Initialize Terraform
terraform init

2. Validate Configuration
terraform validate

3. Plan Infrastructure
terraform plan -out plan.tfplan

4. Apply Changes
terraform apply plan.tfplan

5. Destroy Infrastructure (Cleanup)
terraform destroy

🔒 Security Considerations

Use IAM Roles instead of hardcoded credentials.

Restrict inbound rules in Security Groups to known IPs or ports.

Store Terraform state securely in S3 with encryption and DynamoDB locking.

Keep private subnets for databases inaccessible from the public internet.

🧠 Challenges Faced

Managing dependencies between modules (e.g., VPC and EC2).

Configuring and troubleshooting remote state locking.

Ensuring secure communication between the web and data tiers.

🎯 Key Takeaways

Modularization improves reusability and team collaboration.

Remote state is crucial for maintaining consistent infrastructure across teams.

Terraform provides a powerful way to manage and scale infrastructure declaratively.

📚 References

Terraform Documentation

AWS Well-Architected Framework

AWS Terraform Provider

👨‍💻 Author

Prasad
AWS DevOps Engineer | Cloud Automation Enthusiast
📧 [Your Email or LinkedIn URL]
💻 [GitHub Repository Link]