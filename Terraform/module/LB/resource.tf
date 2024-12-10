resource "aws_lb" "nlb" {
  name                       = "load-test-nlb"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "Load Test Load Balancer"
  }
}

resource "aws_lb_target_group" "nlb" {
  name        = "load-test-tg"
  port        = 80 // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    port                = "traffic-port"
    protocol            = "TCP"
    timeout             = 10
    unhealthy_threshold = 3
  }

  tags = {
    Name = "Load Test lb frontend target group"
  }
}

resource "aws_lb_listener" "tls" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 443 // 클라이언트가 LB에 접근하는 포트(클라이언트->LB)
  protocol          = "TLS"
  certificate_arn   = data.aws_acm_certificate.load_test_issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb.arn
  }

  tags = {
    Name = "Load Test TLS listner"
  }
}

resource "aws_lb_target_group_attachment" "nlb" {
  count            = length(var.ingress_ids)
  target_group_arn = aws_lb_target_group.nlb.arn
  target_id        = var.ingress_ids[count.index]
}
