output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.load_test.id
}

output "subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "lb_subnet_ids" {
  description = "IDs of the load balancer subnets"
  value       = aws_subnet.load_balancer[*].id
}

output "security_group_ids" {
  description = "ID of the security group"
  value = {
    "base"   = aws_security_group.base.id,
    "mongo"  = aws_security_group.mongo.id,
    "redis"  = aws_security_group.redis.id,
    "master" = aws_security_group.master.id,
    "worker" = aws_security_group.worker.id
  }
}
