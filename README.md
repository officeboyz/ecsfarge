# Ouroboros Terraform Repo

- **Network Segmentation and Addressing:**
  The public and private subnet CIDR blocks and their allocations across availability zones are defined in `subnet\cidr\main.tf`. The module's outputs (`subnet\cidr\outputs.tf`) provide these CIDR blocks for use in other modules.

- **ALB Bridge:**
  The Application Load Balancer (ALB) setup, including listener and target group configurations, is located in `subnet\public\chat-tls-balancer`. This is where TLS termination occurs and traffic is routed to the appropriate target group.

- **Multilayer Security:**
    - **NACLS:** Network ACLs are managed through the `cartesian_rule_builder` script located in `subnet\rules\cartesian_rule_builder`, which dynamically creates bidirectional rules.
    - **Security Groups:** Security groups are defined in `security_groups`, where the `main.tf` file contains the actual security group resource definitions and associated rules.
    - **Virtual Endpoints:** Virtual endpoints for AWS services are set up in `subnet\private\virtual_endpoints`, ensuring AWS service traffic does not leave the AWS network. (currently disabled while troubleshooting ecs)
    - **Egress Only Gateways:** The IPv6 egress-only gateway is configured in `subnet\private\main.tf` along with the private route table and NAT gateways for IPv4 traffic.

- **Module Implementation:**
  The approach to module design is evident in the directory structure, with `modules` containing subdirectories for different resources, following the breadcrumb pathing. 
