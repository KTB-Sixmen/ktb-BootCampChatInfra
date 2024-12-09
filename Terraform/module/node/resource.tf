resource "aws_instance" "master" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.small"
  subnet_id              = var.private_subnet_ids[var.instance_indexes["kubernetes"]]
  vpc_security_group_ids = [var.security_group_ids["base"], var.security_group_ids["k8s_master"]]
  private_ip             = var.private_ips["master"]

  tags = {
    Name        = "Gitfolio Kubernetes master node"
    Environment = terraform.workspace
    Service     = "master" # aws_ec2.yaml에서 이 태그로 그룹핑
    Type        = "kubernetes"
  }
}
