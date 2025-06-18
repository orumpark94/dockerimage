locals {
  sg_config = {
    alb = {
      name        = "${var.name}-alb-sg"
      description = "ALB security group"
      ingress     = [{
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }]
    }
    ecs = {
      name        = "${var.name}-ecs-sg"
      description = "ECS security group"
      ingress     = [{
        from_port       = 3000
        to_port         = 3000
        protocol        = "tcp"
        security_groups = [var.alb_sg_id]
      }]
    }
  }
}

resource "aws_security_group" "this" {
  name        = local.sg_config[var.type].name
  description = local.sg_config[var.type].description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.sg_config[var.type].ingress
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", null)
      security_groups = lookup(ingress.value, "security_groups", null)
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.sg_config[var.type].name
  }
}
