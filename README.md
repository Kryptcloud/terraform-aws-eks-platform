# Terraform AWS EKS Platform

## Overview

Terraform AWS EKS Platform is a production-style cloud infrastructure project built to demonstrate Infrastructure as Code (IaC), container orchestration, CI/CD automation, and Kubernetes deployment on AWS.

The platform provisions a complete Amazon EKS environment using modular Terraform architecture, deploys a containerized TypeScript application through GitHub Actions, stores container images in Amazon ECR, and exposes workloads through an Application Load Balancer.

This project was designed to simulate a real-world DevOps deployment workflow where infrastructure provisioning and application delivery are fully automated.



# Architecture

The platform consists of:

* Amazon VPC
* Public and Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Security Groups
* Amazon EKS Cluster
* Managed Node Groups
* Amazon ECR Repository
* GitHub Actions CI/CD Pipeline
* Docker Containerization
* Kubernetes Deployments
* Kubernetes Services
* Kubernetes Ingress
* Application Load Balancer

### High-Level Flow

```text
Developer Push
        │
        ▼
GitHub Actions
        │
        ├── Terraform Infrastructure Deployment
        │
        ▼
Amazon ECR
        │
        ▼
Amazon EKS
        │
        ▼
Kubernetes Pods
        │
        ▼
Application Load Balancer
        │
        ▼
Users

```



# Architecture Diagram
Check Diagram folder on the repo



# Technology Stack

## Cloud

* AWS VPC
* AWS EKS
* AWS ECR
* AWS IAM
* AWS Internet Gateway
* AWS NAT Gateway
* AWS Route Tables
* AWS Security Groups

## Infrastructure as Code

* Terraform

## Containerization

* Docker

## Orchestration

* Kubernetes
* Amazon EKS
* Helm

## CI/CD

* GitHub Actions

## Application

* TypeScript
* Node.js

---

# Project Structure

```text
terraform-aws-eks-platform/
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── app/
│   ├── src/
│   │   └── index.ts
│   ├── Dockerfile
│   └── package.json
│
├── kubernetes/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
│
├── modules/
│   ├── vpc/
│   ├── subnets/
│   ├── igw/
│   ├── nat/
│   ├── route-tables/
│   ├── security-groups/
│   ├── iam/
│   ├── ecr/
│   ├── eks/
│   └── nodegroup/
│
├── diagrams/
│
├── variables/
│   └── dev.tfvars
│
├── main.tf
├── variables.tf
├── outputs.tf
└── providers.tf

```

---

# Infrastructure Components

## VPC

A dedicated Virtual Private Cloud provides network isolation for all platform resources.

```text
CIDR Block: 10.0.0.0/16

```

---

## Public Subnets

Public subnets host:

* NAT Gateway
* Application Load Balancer

```text
10.0.1.0/24
10.0.2.0/24

```

---

## Private Subnets

Private subnets host:

* EKS Worker Nodes
* Kubernetes Pods

```text
10.0.3.0/24
10.0.4.0/24

```

## Internet Gateway

Provides internet connectivity to public resources.

## NAT Gateway

Allows private resources to reach external services without exposing them directly to the internet.

## Security Groups

Security groups control network access between:

* Application Load Balancer
* EKS Worker Nodes
* Kubernetes Workloads

## Amazon EKS

Amazon Elastic Kubernetes Service provides managed Kubernetes control plane services.

Features:

* Multi-AZ deployment
* Managed node groups
* IAM integration
* Load balancer integration

## Amazon ECR

Amazon Elastic Container Registry stores Docker images generated during CI/CD execution.

Repository Example:

```text
dev-my-kubernetes-app

```

---

# Sample Application

A lightweight TypeScript application was created to validate the deployment pipeline.

The application exists solely to provide a deployable container workload for EKS.

## Source Code

```typescript
console.log(
  "Hello from Kryptcloud Platform! EKS is ready to run this container."
);

```

---

# Docker Containerization

The TypeScript application is packaged into a Docker image.

## Build

```bash
docker build -t krypt-app .

```

## Tag

```bash
docker tag krypt-app:latest <ecr-uri>:latest

```

## Push

```bash
docker push <ecr-uri>:latest

```

---

# Kubernetes Deployment

The platform deploys the application into Amazon EKS using:

### Deployment

```text
deployment.yaml

```

Responsible for:

* Pod creation
* Replica management
* Rolling updates

### Service

```text
service.yaml

```

Responsible for:

* Internal traffic routing
* Pod discovery

### Ingress

```text
ingress.yaml

```

Responsible for:

* External access
* ALB integration
* HTTP routing

---

# CI/CD Pipeline

The GitHub Actions workflow is divided into two stages.

## Stage 1: Infrastructure Deployment

Terraform provisions all AWS resources.

### Workflow

```text
Checkout Code
      │
Terraform Init
      │
Terraform Validate
      │
Terraform Plan
      │
Terraform Apply

```

---

## Stage 2: Application Deployment

Application delivery begins only after infrastructure deployment succeeds.

### Workflow

```text
Checkout Code
      │
Build Docker Image
      │
Push Image To ECR
      │
Update Kubernetes Manifest
      │
kubectl Apply

```

---

# Dynamic Image Versioning

Container images are versioned automatically using Git commit hashes.

Kubernetes manifests use a placeholder image reference:

```yaml
image: IMAGE_PLACEHOLDER

```

GitHub Actions replaces the placeholder during deployment:

```bash
sed -i "s|IMAGE_PLACEHOLDER|${IMAGE_URI}|g" kubernetes/deployment.yaml

```

This guarantees that each deployment uses the exact image produced by the current pipeline execution.

---

# Troubleshooting & Engineering Challenges

## Variable Alignment and Cyclic Dependencies

### Issue

When starting out, our Terraform modules were throwing errors because they referenced inconsistent variable names across files (like `var.igw_id` vs `internet_gateway_id`). To make things more complicated, the Internet Gateway module was trying to reference its own output, which triggered a cyclic dependency loop that broke the plan phase.

### Resolution

We cleaned up the module inputs and outputs, standardized the variable names across the root and child modules, and stripped out the self-referencing assignments so the graph could resolve cleanly.

---

## Missing Variables File Path

### Issue

Terraform couldn't locate our `dev.tfvars` file during the pipeline run and kept pausing to ask for manual input for all our cluster variables.

### Resolution

The variables file was tucked away inside a nested directory structure. We updated the execution flags to point directly to the correct relative path:

```bash
terraform plan -var-file="variables/dev.tfvars"

```

---

## Module Output Type Mismatches

### Issue

Terraform threw a `string required, but have object` error. This happened because our VPC and subnet modules were exporting entire resource objects rather than just the specific ID strings needed by downstream resources like the security groups and routing tables.

### Resolution

We modified the child module `outputs.tf` files to explicitly target resource IDs. For example:

```terraform
output "vpc_id" {
  value = aws_vpc.main.id
}

```

---

## CI/CD Pipeline Separation

### Issue

Originally, our infrastructure provisioning (Terraform) and application delivery (Docker/Kubernetes) were crammed into a single massive workflow job. If a pod deployment failed, it made diagnosing whether the underlying infrastructure was broken incredibly messy.

### Resolution

We split the workflow into two clear, independent stages using the `needs:` keyword. This decoupled the compute layer from the application layer, giving us a clean dependency chain where the app only builds if the infrastructure is completely stable.

---

## Local Terminal Context and DNS Drops

### Issue

After running a fresh deployment, local commands like `kubectl get nodes` would suddenly fail with `no such host` or try to point to old cluster endpoints from previous builds.

### Resolution

Whenever EKS or Terraform recreates or updates the cluster control plane, AWS rotates the random API endpoint string. The GitHub runner catches this automatically, but local environments get stuck caching old DNS records and credentials. We fixed this by manually forcing a local configuration update to pull down the live endpoint ID:

```bash
aws eks update-kubeconfig --region eu-north-1 --name dev-eks-cluster

```

---

## AWS Load Balancer Controller CrashLoopBackOff (IMDS Timeouts)

### Issue

The AWS Load Balancer Controller pods kept crashing on startup with a `CrashLoopBackOff` state. Looking at the container logs, we found the culprit:
`failed to get VPC ID: failed to fetch VPC ID from instance metadata: context deadline exceeded`

### Resolution

By default, the controller tries to figure out where it is by hitting the EC2 Instance Metadata Service (IMDS). Because EKS blocks direct pod access to IMDS out of the box for security, the controller simply timed out and died.

Instead of writing massive, complex Terraform blocks to handle native AWS ALB integration at the core infrastructure layer, I decided to handle this cleanly at the Helm delivery stage using IAM roles for service accounts (IRSA). I updated the pipeline step to dynamically query AWS for our runtime account ID and VPC ID, then injected those parameters straight into the Helm configuration flags to bypass IMDS completely:

```yaml
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
VPC_ID=$(aws eks describe-cluster --name dev-eks-cluster --region eu-north-1 --query "cluster.resourcesVpcConfig.vpcId" --output text)

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=dev-eks-cluster \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::${AWS_ACCOUNT_ID}:role/dev-aws-load-balancer-controller-role \
  --set vpcId=${VPC_ID} \
  --set region=eu-north-1

```

---

## Ingress Target Subnet Auto-Discovery Failures

### Issue

Once the controller was running smoothly, running `kubectl get ingress` still left our public `ADDRESS` field completely blank. Running a `kubectl describe ingress` showed an error event:
`couldn't auto-discover subnets: unable to resolve at least one subnet. Evaluated 2 subnets: 2 are tagged for other clusters`

### Resolution

The controller couldn't automatically determine which public subnets were safe to attach to an internet-facing load balancer due to overlapping cluster tags. To bypass auto-discovery entirely, I pulled our cluster's exact subnets directly via the AWS CLI:

```bash
aws eks describe-cluster --name dev-eks-cluster --region eu-north-1 --query "cluster.resourcesVpcConfig.subnetIds" --output text

```

Then, I hardcoded those subnet IDs right into the `kubernetes/ingress.yaml` annotations, forcing the controller to use our specific public-facing subnets:

```yaml
metadata:
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/subnets: subnet-09b57e2468611cb48, subnet-0defbdaf9e7427c0c

```

---

# Validation

The platform was successfully validated through:

* Terraform deployment success
* EKS cluster creation
* Node group registration
* ECR image storage
* Docker image builds
* Kubernetes deployments
* GitHub Actions automation
* Application Load Balancer provisioning with a live public address



# Skills Demonstrated

* Infrastructure as Code (Terraform)
* AWS Networking & VPC Design
* Amazon EKS Administration
* Helm Chart Deployments
* Amazon ECR Management
* Docker Containerization
* Kubernetes Workloads & Networking
* GitHub Actions CI/CD Pipelines
* IAM Configuration & IRSA (IAM Roles for Service Accounts)
* Routing and Security Group Topology
* Production Infrastructure Troubleshooting



# Author

**Fidelis Adibe (kryptcloud)**

DevOps Engineer | Cloud Infrastructure Engineer

Focused on building scalable cloud platforms using AWS, Terraform, Kubernetes, Docker, GitHub Actions, and Infrastructure as Code principles.