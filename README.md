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
flowchart LR
  %% Layer 1: Edge
  subgraph EDGE["Layer 1: Edge / Internet"]
    Internet((Internet))
    IGW[Internet Gateway]
    Internet --> IGW
  end

  %% Layer 2: Public Zone
  subgraph PUBLIC["Layer 2: Public Zone (DMZ)"]
    PublicRT[Public Route Table]
    Public1[Public Subnet 1<br/>10.0.1.0/24]
    Public2[Public Subnet 2<br/>10.0.2.0/24]
    NAT[NAT Gateway + Elastic IP]
    IGW --> PublicRT
    PublicRT --> Public1
    PublicRT --> Public2
    Public1 --> NAT
  end

  %% Layer 3: Private Zone
  subgraph PRIVATE["Layer 3: Private Zone"]
    PrivateRT[Private Route Table]
    Private1[Private Subnet 1<br/>10.0.11.0/24]
    Private2[Private Subnet 2<br/>10.0.12.0/24]
    EC2[Private EC2 Instance]
    PrivateRT --> Private1
    PrivateRT --> Private2
    Private1 --> EC2
  end

  %% Layer 4: Egress/Return Path
  subgraph FLOW["Layer 4: Controlled Egress"]
    PrivateRT --> NAT
    NAT --> IGW
  end

  classDef edge fill:#0b132b,stroke:#5bc0be,stroke-width:2px,color:#ffffff;
  classDef public fill:#1c2541,stroke:#3a86ff,stroke-width:2px,color:#ffffff;
  classDef private fill:#16213e,stroke:#2ec4b6,stroke-width:2px,color:#ffffff;
  classDef compute fill:#2b2d42,stroke:#ffbe0b,stroke-width:2px,color:#ffffff;
  classDef flow fill:#3a0ca3,stroke:#f72585,stroke-width:2px,color:#ffffff;
  classDef route fill:#264653,stroke:#e9c46a,stroke-width:2px,color:#ffffff;
  classDef nat fill:#5a189a,stroke:#ff006e,stroke-width:2px,color:#ffffff;

  class Internet,IGW edge;
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