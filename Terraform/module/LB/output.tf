output "nlb_zone_id" {
  description = "Zone ID of the NLB"
  value       = aws_lb.nlb.zone_id
}

output "nlb_dns_name" {
  description = "DNS name of the NLB"
  value       = aws_lb.nlb.dns_name
}
