resource "aws_vpc" "load_test" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Load Test VPC"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.subnet_cidrs) - 2
  vpc_id                  = aws_vpc.load_test.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = count.index % 2 == 0 ? "ap-northeast-2a" : "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = format("Load Test %s subnet-%s", var.subnet_names[floor(count.index / 2)], count.index % 2 == 0 ? "2a" : "2c")
  }
}

resource "aws_subnet" "load_balancer" {
  count                   = 2
  vpc_id                  = aws_vpc.load_test.id
  cidr_block              = var.subnet_cidrs[length(var.subnet_cidrs) - 2 + count.index]
  availability_zone       = count.index % 2 == 0 ? "ap-northeast-2a" : "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = format("Load Test Load Balancer subnet-%s", count.index % 2 == 0 ? "2a" : "2c")
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.load_test.id

  tags = {
    Name = "Load Test Internet Gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.load_test.id

  route {
    cidr_block = var.any_ip
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Load Test public route table"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "base" {
  name   = "base_sg"
  vpc_id = aws_vpc.load_test.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Load Test base security group"
  }
}

resource "aws_security_group" "master" {
  name   = "k8s_master_sg"
  vpc_id = aws_vpc.load_test.id

  ingress {
    description = "Kubernetes API"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "etcd API"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "kube-scheduler"
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "kube-controller-manager"
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "kubernetes-dashboard"
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Load Test k8s master node security group"
  }
}

resource "aws_security_group" "worker" {
  name   = "k8s_worker_sg"
  vpc_id = aws_vpc.load_test.id
  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  ingress {
    description = "NodePort"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Load Test k8s worker node security group"
  }
}

resource "aws_security_group" "mongo" {
  name   = "mongo_sg"
  vpc_id = aws_vpc.load_test.id

  ingress {
    description = "MongoDB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Load Test MongoDB security group"
  }
}

resource "aws_security_group" "redis" {
  name   = "redis_sg"
  vpc_id = aws_vpc.load_test.id

  ingress {
    description = "Redis"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.any_ip]
  }

  tags = {
    Name = "Load Test Redis security group"
  }
}
