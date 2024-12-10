variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the subnets"
  type        = list(string)
}

variable "ingress_ids" {
  description = "IDs of the ingress instances"
  type        = list(string)
}
