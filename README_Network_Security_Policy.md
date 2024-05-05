# Ouroboros Network Security Policy

Welcome to the Ouroboros Network Security Policy. This document reflects our unwavering commitment to safeguarding our infrastructure while navigating the complexities of technological evolution and resource management. Our policy is structured around a comprehensive security strategy that ensures both immediate protections and a roadmap towards an even more secure and efficient network architecture.

## Introduction to Our Security Philosophy

At Ouroboros, security is not just a feature but the foundation of our infrastructure design. Our approach is proactive, thoughtful, and adaptive, ensuring that we not only address current security needs but also anticipate future challenges and opportunities for enhancement.

### Core Principles

#### Deny-By-Default Network
We operate on a principle that inherently distrusts all traffic, permitting only those communications explicitly allowed by our meticulously configured Network Access Control Lists (NACLs) and security groups. This "deny-by-default" stance significantly minimizes potential attack vectors.

#### Encryption: A Tiered Strategy
Our encryption strategy is tiered, acknowledging the varying levels of sensitivity and interaction data undergoes within our network:

- **In-Transit Data**: Leveraging industry-standard protocols like TLS, alongside AWS-native encryption services, forms our primary defense against data interception. This baseline ensures that data moving across our network to external services remains protected.

  We are actively exploring enhancements through service mesh technologies to extend this protection to all internal communications. This future state aims for a seamless overlay of encryption, mediated by a service proxy, enabling our services to communicate freely and securely without modification.

- **At-Rest Data**: Data stored within our ecosystem, irrespective of its current use or sensitivity, is encrypted by default. Utilizing AWS's encryption capabilities, we ensure that our data at rest is inaccessible to unauthorized entities, aligning with best practices and regulatory requirements.

## Implementation and Operations

### Infrastructure as Code (IaC)
Our security configurations, from firewall rules to access policies, are codified using Terraform. This practice not only ensures consistency and minimizes human error but also provides a clear audit trail for all changes, aligning with compliance demands.

### Deployment and Policy Evolution
While we currently adopt a manual deployment strategy for Terraform changes, our goal is to transition to automated, CI/CD-based deployments. This evolution will enhance our operational efficiency and ensure that security updates are propagated swiftly and reliably across our infrastructure.

## Strategic Initiatives

### Modernization and Principle of Least Privilege
Our policy development is guided by a commitment to modern security standards and the principle of least privilege. Whether evaluating the implementation of IPv6 or refining access controls, our decisions are weighed against their security impact and the principle of minimal necessary access.

#### Case Study: Network Segmentation
An illustrative example of our strategic decision-making involved network segmentation across availability zones. Initially aimed at granular inter-zone communication controls, we adapted our approach in light of NACL rule limits and operational feasibility, opting instead for broader subnet-based segmentation. This pivot underscores our flexibility and pragmatism, balancing security granularity with operational sustainability.

## Future Directions

As we look ahead, our vision for Ouroboros's network security encompasses a fully encrypted environment, underpinned by automated, proxy-based encryption for internal communications. This ambitious goal seeks not only to elevate our security posture but also to align our infrastructure with emerging security paradigms and compliance standards.

In pursuit of this vision, we remain committed to continuous improvement, leveraging advances in technology, insights from our operations, and feedback from our security audits. Our journey is one of perpetual evolution, driven by the dual mandates of uncompromising security and operational excellence.

# Updates
## Security Group Spec Update
I initially fully specified every security group by both cidr block and source security group.
Unfortunately this is not allowed, you have to pick one or the other.
Thus, since we have nacl for cidr based filtering, I opted to make the security group pairings entirely on security id without cidrs (because nacls cover cidrs).

## ipv4 gimmicks
According to aws, the correct way to force ipv4 is to set "assign_public_ip" to false and hope that you inherit an ipv6.
Ugh, aws refuses to allow ipv6 exclusive networks because... aws is lagging behind. Thus the task will have to be dualstack for now, gross as that is.


