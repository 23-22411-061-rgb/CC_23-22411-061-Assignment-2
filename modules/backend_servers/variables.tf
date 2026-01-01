variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "key_name" {}
variable "script_path" {
  description = "Path to the setup script for backend instances"
  type        = string
}

