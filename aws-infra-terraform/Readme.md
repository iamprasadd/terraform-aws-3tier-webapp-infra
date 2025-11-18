
# AWS Two-Tier Infrastructure with Terraform – End‑to‑End Project

This project demonstrates a full production‑ready **AWS Two‑Tier Architecture** built using **Terraform**, fully modularized, environment‑specific (dev/stage/prod), and automated with **GitHub Actions CI/CD**.  
It includes networking, security, compute, load balancing, RDS MySQL, Route53, ACM, and automated Terraform pipelines.

---

## 📸 Architecture Diagram
![Architecture Diagram](./.images/2tier-web-application-architecture.png)

---

---

## 🚀 Architecture Overview

The deployed AWS infrastructure follows this structure:

- **VPC (10.10.0.0/16)**
- **Public Subnets (2 AZs)** → ALB + NAT Gateways  
- **Private App Subnets (2 AZs)** → Auto Scaling Group (EC2)
- **Private DB Subnets (2 AZs)** → RDS MySQL Multi‑AZ
- **ALB** for routing inbound traffic
- **Security Groups** for ALB, EC2, and RDS
- **ACM TLS certificate (HTTPS)**
- **Route53 alias record** for domain → ALB
- **GitHub Actions CI/CD**
- **Terraform Remote Backend (S3 + DynamoDB Locking)**

---

## 📂 Repository Structure

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
└── .github/workflows/
    └── terraform-ci.yml
```

---

## 🧠 Key Learnings & Challenges Faced

During this project, several real‑world issues were encountered and resolved.  
These challenges strengthened the understanding of Terraform, AWS architecture, and CI/CD practices.

### **1. ASG Instances Unhealthy (ALB Health Check Failures)**  
**Issue:** ALB continuously marked instances as *unhealthy*, causing an infinite loop of instance termination.  
**Root causes:**
- User‑data not installing NGINX correctly.
- SSM agent failing → instance boot failure.
- Wrong health check path `/`.

**Fix:**  
Simplified user‑data, added retry logic, ensured service enable/start, and corrected ALB health check config.

---

### **2. SSM Not Working on EC2**  
**Issue:** EC2 instances were not appearing in Systems Manager.  
**Reason:** Missing IAM role + SSM policy.

**Fix:**  
Attached required policies:
- `AmazonSSMManagedInstanceCore`
- Created proper IAM Role + Instance Profile.

---

### **3. NAT Gateway Routing Confusion**  
**Issue:** Why NAT Gateway is placed in **public** subnets when it is used by **private** subnets?  
**Learning:**  
NAT must be in a public subnet so it can use the Internet Gateway for outbound traffic.

---

### **4. ACM Certificate Validation Failure**  
**Issue:** ACM threw domain validation errors because the provided domain was invalid.  
**Fix:**  
Used a valid Route53‑registered domain.

---

### **5. Route53 Not Finding Hosted Zone**  
**Issue:** Terraform said: *couldn't find hosted zone*.  
**Fix:**  
Provided correct hosted zone ID and region.

---

### **6. GitHub Actions: Terraform Validation Failed**  
**Issues faced:**
- Wrong working directory in workflow.
- Missing root `main.tf` in environment.
- Terraform Segmentation Fault (Exit Code 11).
- AWS provider error: “failed to get shared config profile”.

**Fixes:**
- Updated terraform version.
- Cleaned `.terraform` directory.
- Removed `profile = default` from provider.
- Passed AWS credentials using GitHub Secrets only.

---

### **7. GitHub Actions Remote Backend Failing**  
**Issue:** S3 bucket creation initially failed due to wrong LocationConstraint for `us-east-1`.

**Fix:**  
Created bucket without region parameter.

---

### **8. Code Formatting Issues (terraform fmt)**  
When running:
```
terraform fmt -recursive -check
```
Format issues were found in multiple module files.

**Fix:**  
Ran full recursive formatting to standardize the entire repo.

---

### **9. Variables Prompted in CI Pipeline**  
Pipeline got stuck on:
```
var.db_username Enter a value:
```

**Fix:**  
Added environment‑specific `terraform.tfvars`.

---

### **10. Duplicate Listener Error**  
ALB already had an HTTP listener on port 80.

**Fix:**  
Handled HTTP → HTTPS redirect properly and removed duplicate resource.

---

## 🔧 CI/CD – GitHub Actions Setup

Your workflow handles:

- Terraform FMT
- Terraform Init
- Terraform Validate
- Terraform Plan
- Terraform Apply (only on `main`)

The key part:
```yaml
terraform init -input=false
terraform plan -lock=false -input=false
```

> Removed profiles + injected AWS keys through GitHub Secrets.

---

## 💡 Improvements Planned

- Add CloudFront CDN
- Add WAF for ALB
- Add automated drift detection workflow
- Add Lambda scheduled cleanup tasks
- Add cost alerts & monitoring with CloudWatch

---

## 📘 Conclusion

This infrastructure represents a production‑grade, modular, scalable setup built entirely using Terraform, following DevOps best practices and automated through GitHub Actions.  
Every challenge solved added clarity to AWS networking, Terraform architecture design, and CI/CD pipelines.

If you want to extend this to a **three‑tier**, **Kubernetes**, or **microservices** setup, the foundation is already strong.

---
