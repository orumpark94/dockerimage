resource "aws_lb" "alb" {
  name               = "${var.name}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.sg_id]  # ✅ 외부에서 주입받은 ALB SG 사용

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.name}-tg"
  port        = var.target_port     # ✅ 외부에서 ECS 포트 주입 (ex. 3000)
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"                # ✅ awsvpc 필수

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.name}-tg"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
