
# AWS Two-Tier Infrastructure with Terraform

This repository delivers a production-ready **AWS Two-Tier Architecture** built using **Terraform**, fully modularized, environment-driven (dev/stage/prod), and automated through **GitHub Actions CI/CD**. It provisions networking, compute, database layers, and secure boundaries following AWS best practices.

---

## 📸 Architecture Diagram

![Architecture Diagram](./.images/2tier-web-application-architecture.png)

---

## What This Project Does

This project deploys a complete AWS application stack:

- **VPC** with public, private-app, and private-db subnets  
- **Internet Gateway + NAT Gateways** for secure outbound access  
- **Route Tables** for tiered traffic control  
- **Application Load Balancer (ALB)** for HTTP/HTTPS  
- **Auto Scaling Group (ASG)** with Launch Template  
- **RDS MySQL** in Multi-AZ private subnets  
- **Security Groups** per component (ALB, EC2, DB)  
- **ACM Certificate** for HTTPS  
- **Route53 DNS** with alias record to ALB  
- **Remote backend** using S3 (state) + DynamoDB (locking)  
- **GitHub Actions pipeline** for validation & planning  

Infrastructure is organized into clean modules in the `modules/` directory and deployed per environment inside `envs/`.

---

## Why This Project Is Useful

This repo offers:

- **Predictable, repeatable infrastructure** using Terraform modules  
- **Secure defaults** (private subnets, restricted DB access, SSM access, no SSH)  
- **Centralized CI/CD pipeline** to validate every push  
- **Isolated environments** for dev, stage, and prod  
- **Scalable base design** that can grow into microservices, EKS, or 3‑tier systems  

It’s ideal for teams wanting clean infrastructure structure without vendor lock‑in.

---

## 🧠 Key Challenges Faced & How They Were Solved

Real-world problems arose during development, similar to production systems.  
Here are the most valuable takeaways:

---

### **1. ASG Instances Terminating Repeatedly (Unhealthy ALB Checks)**  
**Issue:**  
Instances constantly replaced because ALB health checks failed.

**Why it happened:**  
- NGINX failed to install on first boot  
- SSM agent failed silently  
- User‑data didn't execute fully  
- ALB checked `/` before NGINX was running  

**Fix:**  
- Simplified & stabilized user‑data  
- Ensured correct service order  
- Tuned ALB health-check intervals  

---

### **2. EC2 Not Appearing in SSM**  
**Cause:** Missing IAM role & SSM policy.  
**Fix:** Attached `AmazonSSMManagedInstanceCore` and proper instance profile.

---

### **4. ACM Certificate Validation Errors**  
**Cause:** Invalid domain names and missing hosted zone.  
**Fix:** Used Route53 domain and automatic DNS validation.

---

### **5. Route53 Hosted Zone Lookup Failure**  
Terraform could not locate the zone.  
**Fix:** Linked correct Hosted Zone ID from module outputs.

---

### **6. GitHub Actions Failing with Terraform Segmentation Fault (Exit 11)**  
**Cause:** Cached providers, old Terraform version, corrupted `.terraform` directory.  
**Fix:** Upgraded Terraform, cleared providers, reinitialized environment.

---

### **7. Pipeline Error: “Failed to Get Shared Config Profile”**  
**Reason:** GitHub runners don’t support `profile = "default"`.  
**Fix:** Removed profiles, used GitHub Secrets for AWS credentials.

---

### **8. Backend Creation Error for S3 in us-east-1**  
**Fix:** Created S3 bucket without region parameter (special behavior for us-east-1).

---

### **9. CI Pipeline Prompting for Variables**  
Pipeline asked for:  
```
var.db_username Enter a value:
```  
**Fix:** Added environment-specific `terraform.tfvars`.

---

### **10. Duplicate ALB Listener Error**  
**Cause:** Two listeners on port 80 created.  
**Fix:** Cleaned HTTPS redirect logic.

---

## Getting Started

### 1. Clone the Project

```bash
git clone https://github.com/imprasadd/repo.git
cd aws-2tier/envs/dev
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Apply Infrastructure

```bash
terraform apply
```

Populate variables in `terraform.tfvars` for each environment.

---

## Project Structure

```
aws-2tier/
│
├── modules/
│   ├── vpc/
│   ├── subnets/
│   ├── routing/
│   ├── security/
│   ├── alb_asg/
│   ├── rds/
│   └── route53/
│
├── envs/
│   ├── dev/
│   ├── stage/
│   └── prod/
│
├── .github/workflows/
│   └── terraform-ci.yml
│   
├── main.tf
├── providers.tf
├── variables.tf
└── README.md
```

---

## Getting Help

- Terraform Docs: https://developer.hashicorp.com/terraform  
- AWS Documentation for ALB, VPC, RDS, Route53  
- Open issues or discussions in the repository

---

## Maintainer

**Prasad** — DevOps Engineer  
GitHub: https://github.com/iamprasadd

Contributions welcome.  
Create issues or submit PRs.

