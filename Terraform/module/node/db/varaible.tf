variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the subnets"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = map(string)
}

variable "instance_index" {
  description = "Index of the instance"
  type        = number
}

variable "instance_type" {
  description = "Type of the instance"
  type        = string
}
