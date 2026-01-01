
# Assignment 2 - Multi-Tier Web Infrastructure
i
## Project Overview
This project implements a multi-tier web infrastructure using AWS EC2 instances, Nginx load balancer, SSL/TLS, caching, and health checks. The architecture supports 3 backend servers with load balancing and failover.

## Architecture Diagram
       ┌─────────────────────────────────────────┐
       │                  Internet               │
       └─────────────────┬──────────────────────┘
                         │
              HTTPS (443) │  HTTP (80)
                         ▼
              ┌────────────────────┐
              │     Nginx Server    │
              │   (Load Balancer)   │
              │    - SSL/TLS       │
              │    - Caching       │
              │  - Reverse Proxy   │
              └────────┬───────────┘
                       │
     ┌─────────────────┼─────────────────┐
     ▼                 ▼                 ▼
  ┌─────┐           ┌─────┐           ┌─────┐
  │Web-1│           │Web-2│           │Web-3│
  │     │           │     │           │(BKP)│
  └─────┘           └─────┘           └─────┘
  Primary            Primary           Backup

## Components
- **Nginx Server**: Handles SSL termination, caching, load balancing, custom error pages, and rate limiting.
- **Web-1 & Web-2**: Primary backend Apache servers.
- **Web-3**: Backup server for failover.

## Prerequisites
- AWS account with appropriate IAM permissions.
- SSH key pair for EC2 access.
- Terraform installed.
- AWS CLI configured.

## Deployment Instructions
1. Configure `terraform.tfvars` with AWS credentials, region, VPC, subnet, and EC2 instance details.  
2. Initialize Terraform: 
   `terraform init`  
3. Plan the deployment: 
   `terraform plan`  
4. Apply the Terraform configuration: 
   `terraform apply` (Type `yes` when prompted)  
5. SSH into Nginx and backend servers:  
   - `ssh -i key.pem ec2-user@<nginx-ip>`  
   - `ssh -i key.pem ec2-user@<web-ip>`

## Configuration Guide
1. **Update Backend IPs**: Modify `/etc/nginx/conf.d/default.conf` → `upstream backend_servers { ... }`  
2. **Nginx Explanation**:
   - Custom error pages: `error_page 404 /errors/404.html;` etc.  
   - SSL/TLS: `/etc/ssl/certs/selfsigned.crt`  
   - Caching: `proxy_cache` and `keys_zone`  
   - Rate limiting: `limit_req_zone` and `limit_req`

## Testing Procedures
- Browser test: `https://<nginx-ip>` → check load balancing and caching headers (`X-Cache-Status`)  
- 404 page: visit a non-existent URL  
- 502 page: stop a backend server  
- Rate limiting: run multiple rapid requests via `curl` or `ab`

## Architecture Details
1. **Network Topology**: VPC → Subnet → EC2 → Nginx → Backend  
2. **Security Groups**:
   - Nginx SG: allow 22, 80, 443  
   - Backend SG: allow only traffic from Nginx SG  
3. **Load Balancing Strategy**: Round-robin across Web-1 and Web-2, Web-3 as backup

## Troubleshooting
1. **Common Issues**:
   - ERR_CERT_AUTHORITY_INVALID: self-signed SSL warning  
   - 502 Bad Gateway: backend server stopped  
2. **Log Locations**:
   - Nginx: `/var/log/nginx/error.log`  
   - Apache: `/var/log/httpd/access_log` and `/var/log/httpd/error_log`  
3. **Debug Commands**:
```bash
ps aux | grep nginx
sudo systemctl status httpd
sudo systemctl status nginx
curl -k -v https://<nginx-ip>
```
## 6.2 Infrastructure Cleanup (5 marks)

This section documents the destruction of all AWS resources created for Assignment 2.

### Cleanup Steps
1. Navigate to the project directory in Git Bash:  
   `cd ~/Assignment2`

2. Destroy all Terraform-managed resources:  
   `terraform destroy`  
   (Type `yes` when prompted)
- Screenshot: `assignment_part6_terraform_destroy_prompt.png`  
- Screenshot: `assignment_part6_terraform_destroy_complete.png`

### Verification Steps
3. Verify Terraform state file is empty:  
   `cat terraform.tfstate`

- Screenshot: `assignment_part6_empty_state.png`

4. Confirm in AWS Console that no EC2 instances exist for Assignment-2.

- Screenshot: `assignment_part6_aws_instances_destroyed.png`

### Notes
- All commands were executed using **Git Bash**.
- No resources were deleted manually.
- Terraform successfully cleaned up all infrastructure.

## Deliverables
- Screenshot: `assignment_part6_readme.png` (README.md content)
- Screenshot: `assignment_part6_terraform_destroy_prompt.png`
- Screenshot: `assignment_part6_terraform_destroy_complete.png`
- Screenshot: `assignment_part6_aws_instances_destroyed.png`
- Screenshot: `assignment_part6_empty_state.png`
