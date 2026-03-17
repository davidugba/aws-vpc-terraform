# AWS VPC Terraform Project

## Architecture Overview
This project provisions a production-style VPC foundation:
- 1 VPC (`10.0.0.0/16`)
- 2 public subnets (`10.0.1.0/24`, `10.0.2.0/24`)
- 2 private subnets (`10.0.11.0/24`, `10.0.12.0/24`)
- Internet Gateway for public ingress/egress
- NAT Gateway for private subnet outbound internet access
- Public and private route tables with subnet associations
- Private EC2 instance with VPC-internal access controls

## Architecture Diagram

```mermaid
flowchart TD
  Internet[Internet] --> IGW[Internet Gateway]

  IGW --> PublicRT[Public Route Table]
  PublicRT --> Public1[Public Subnet 1<br/>10.0.1.0/24]
  PublicRT --> Public2[Public Subnet 2<br/>10.0.2.0/24]

  Public1 --> NAT[NAT Gateway + Elastic IP]

  PrivateRT[Private Route Table] --> Private1[Private Subnet 1<br/>10.0.11.0/24]
  PrivateRT --> Private2[Private Subnet 2<br/>10.0.12.0/24]

  Private1 --> EC2[Private EC2 Instance]
  Private1 --> PrivateRT
  Private2 --> PrivateRT

  PrivateRT --> NAT
  NAT --> IGW

  classDef internet fill:#ffe6cc,stroke:#cc7a00,stroke-width:2px,color:#1f1f1f;
  classDef public fill:#d6f5ff,stroke:#1f78b4,stroke-width:2px,color:#1f1f1f;
  classDef private fill:#e7ffe7,stroke:#2e8b57,stroke-width:2px,color:#1f1f1f;
  classDef compute fill:#f3e8ff,stroke:#6a3d9a,stroke-width:2px,color:#1f1f1f;
  classDef route fill:#fff7cc,stroke:#b8860b,stroke-width:2px,color:#1f1f1f;
  classDef nat fill:#ffd6d6,stroke:#c0392b,stroke-width:2px,color:#1f1f1f;

  class Internet,IGW internet;
  class Public1,Public2 public;
  class Private1,Private2 private;
  class EC2 compute;
  class PublicRT,PrivateRT route;
  class NAT nat;
```

## Why This Design
- Public subnets host internet-facing network components.
- Private subnets isolate workloads from direct internet exposure.
- NAT enables private workloads to fetch updates without public IPs.
- Multi-AZ subnets improve resilience.

## Resources Created
- `aws_vpc.main`
- `aws_subnet.public_1`
- `aws_subnet.public_2`
- `aws_subnet.private_1`
- `aws_subnet.private_2`
- `aws_internet_gateway.main`
- `aws_eip.nat`
- `aws_nat_gateway.main`
- `aws_route_table.public`
- `aws_route_table.private`
- `aws_route_table_association.*`
- `aws_security_group.private_ec2`
- `aws_instance.private_app`

## How to Use
```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

## Validation
- Confirm VPC and subnets exist in AWS console.
- Confirm public subnets have route to Internet Gateway.
- Confirm private subnets use private route table with default route to NAT Gateway.
- Confirm private EC2 instance has no public IP.
- Confirm security group allows only VPC-internal SSH/HTTP ingress.

## Cost Notes
- NAT Gateway is a key cost driver in this architecture.
- EC2 instance hourly usage and data transfer can add cost.
- Elastic IP for NAT may incur charges if unused.
- Destroy resources after practice to avoid unnecessary billing.

## Cleanup
```bash
terraform destroy
```