# --- loadbalancing/main.tf ---

resource "aws_lb" "dev_lb" {
  name            = "dev-loadbalancer"
  subnets         = var.public_subnets
  security_groups = var.public_sg
  idle_timeout    = 400
}

resource "aws_lb_target_group" "dev_tg" {
  name     = "dev-lb-tg-${substr(uuid(), 0, 3)}"
  port     = var.tg_port     # 80 
  protocol = var.tg_protocol # HTTP
  vpc_id   = var.vpc_id
  # ignore_changes se poradi toa sto imeto se menuva postojano na target grupata, create_before_destroy e poradi toa shto mora
  # da se kreira prvo target grupata bidejki listenerot se atachira na target grupata
  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }

  health_check {
    healthy_threshold   = var.lb_healthy_threshold   # 2
    unhealthy_threshold = var.lb_unhealthy_threshold # 2
    timeout             = var.lb_timeout             # 3
    interval            = var.lb_interval            # 30
  }
}

resource "aws_lb_listener" "dev_lb_listener" {
  load_balancer_arn = aws_lb.dev_lb.arn
  port              = var.listener_port     # 80
  protocol          = var.listener_protocol # "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_tg.arn
  }
}