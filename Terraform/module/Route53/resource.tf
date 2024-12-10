resource "aws_route53_record" "load_test" {
  count   = terraform.workspace == "prod" ? 1 : 0
  zone_id = data.aws_route53_zone.load_test.zone_id
  name    = "goorm-ktb-012.goorm.team"
  type    = "A"

  alias {
    name                   = substr(var.nlb_dns_name, 0, length(var.nlb_dns_name))
    zone_id                = var.nlb_zone_id
    evaluate_target_health = true
  }
}
