resource "aws_instance" "worker" {
  ami           = var.ami_id
  instance_type = "t3.small"
  key_name      = "admin_key"
  subnet_id     = var.subnet_ids[var.instance_index]
  vpc_security_group_ids = [
    var.security_group_ids["base"],
    var.security_group_ids["worker"]
  ]

  tags = {
    Name    = "Load Test ${var.instance_type}${var.instance_index + 1}"
    Service = "worker"
    Type    = var.instance_type
  }
}
