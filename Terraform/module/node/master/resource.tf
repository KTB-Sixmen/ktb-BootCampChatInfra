resource "aws_instance" "master" {
  ami           = var.ami_id
  instance_type = "t3.small"
  key_name      = "admin_key"
  subnet_id     = var.subnet_ids[var.instance_index]
  vpc_security_group_ids = [
    var.security_group_ids["base"],
    var.security_group_ids["master"]
  ]

  tags = {
    Name    = "Load Test Kubernetes master node${var.instance_index + 1}"
    Service = "master"
    Type    = "master"
    Index   = var.instance_index
  }
}
