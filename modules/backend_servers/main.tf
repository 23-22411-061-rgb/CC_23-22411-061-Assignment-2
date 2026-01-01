resource "aws_instance" "backend" {
  count                  = 3
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  tags = {
    Name = "web-${count.index + 1}"
  }
}

output "instance_id" {
  value = aws_instance.backend[*].id
}

output "public_ip" {
  value = aws_instance.backend[*].public_ip
}

output "private_ip" {
  value = aws_instance.backend[*].private_ip
}

