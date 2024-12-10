data "aws_acm_certificate" "load_test_issued" {
  domain   = "*.goorm-ktb-012.goorm.team"
  statuses = ["ISSUED"]
}
