data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"] // AMI 소유자

  filter {
    name   = "name" // AMI 이름
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type" // 가상화 타입
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture" // 이미지 아키텍처
    values = ["x86_64"]
  }
}
