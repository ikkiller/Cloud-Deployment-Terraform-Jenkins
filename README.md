# Mini Cloud Deployment Project

This project demonstrates a **small cloud deployment** using 
- **Terraform** for infrastructure, 
- **Jenkins** for CI/CD, and a simple **Nginx web app** hosted on an **Ubuntu EC2 instance**. 

## Architecture Choices
- **Cloud provider**: AWS (widely used, good free-tier options for small demos).
- **EC2 (Ubuntu)**: Hosts the "Hello World" web service using Nginx. Ubuntu was chosen for its lightweight nature and ease of configuration.
- **CloudWatch Metrics & Alarms**: Monitors:
  - EC2 system status (`StatusCheckFailed`)
  - Nginx HTTP response (`HTTPCheckFailed`) via a custom metric. This provides uptime visibility without storing logs.
- **VPC, Subnet, Security Group**: Managed via Terraform for secure networking.
- **IAM Role & Instance Profile**: Allows EC2 to push CloudWatch metrics with **minimal permissions** (`PutMetricData` only).

### CI/CD

- **Jenkins**: Automates the pipeline with three stages:
  - **Build**: Prepares the HTML file (dummy build step)
  - **Test**: Runs a simple validation to check HTML content
  - **Deploy**: Copies the HTML file to EC2 and restarts Nginx

- **Jenkins Credentials**:
  - `server_ip` (Secret Text): EC2 public IP
  - `SSH_KEY` (Secret File): PEM key for secure SSH access

---

## Folder Structure
```zsh
.
├── Code
│   └── Index.html
├── Infra
│   └── terraform
│       ├── EC2.tf
│       ├── IAM.tf
│       ├── Security_group.tf
│       ├── monitoring.tf
│       ├── network.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── Jenkinsfile
├── LICENSE
├── README.md
├── README.md.bkp
└── scripts
    ├── dummy_test.sh
    └── user_data.sh
```

## How to Run / Simulate the Setup

### Prerequisites

Make sure you have the following:

- [Terraform](https://developer.hashicorp.com/terraform/install)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Jenkins (locally or on a server)
- An AWS IAM user with access to EC2, VPC, and CloudWatch
- A Key pair used to SSH into EC2 instance.

### 1. Infrastructure Setup (Terraform)
```bash
# Navigate to the folder containing the terraform code.
$ cd Infra/terraform
# Initialize the project so terraform knows where to do what.
$ terraform init
# Do a terraform plan just to be sure.
$ terraform plan
# Once you have confirmed the changes that are going to be made enter Y when prompted.
$ terraform apply
```

### 2. Jenkins Pipeline

1. Ensure Jenkins has global credentials:
    - `server_ip` → EC2 public IP (Secret Text)
    - `SSH_KEY` → PEM key (Secret File)
2. Create a new Jenkins pipeline pointing to the `Jenkinsfile`.
3. Run the pipeline:
    - Build Stage: Prepares the HTML file
    - Test Stage: Validates HTML content
    - Deploy Stage: Copies HTML to EC2 and restarts Nginx

### 3. HTML Page
The HTML file `Code/Index.html` is deployed to `/var/www/html/index.html` on the EC2 instance via Jenkins.

### 4. Monitoring
- EC2 System Check: CloudWatch alarm triggers if EC2 fails its health check.
- Nginx HTTP Check: A cron job in `user_data.sh` sends the `HTTPCheckFailed` metric every minute.
- No logs are stored, keeping the setup simple.

### 5. Clean up
```bash
# Clean up infrastructure.
$ terraform destroy 
```

### Production-Ready Improvements
- High Availability
  - Use an ALB with multiple EC2 instances across AZs
  - Add an Auto Scaling Group for automatic replacement of unhealthy instances
- CI/CD Enhancements
  - Add rollback on deployment failure
  - Implement comprehensive unit, integration, and UI tests
- Security
  - Use Secrets Manager for credentials
  - Enable HTTPS with SSL certificates
- Monitoring & Alerts
  - Store logs in CloudWatch Log Groups for debugging
  - Configure SNS or email notifications for alarms
- Infrastructure Improvements
  - Parameterize AMI IDs
  - Use Terraform modules for reusability
