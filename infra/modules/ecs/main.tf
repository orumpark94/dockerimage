resource "aws_ecs_task_definition" "task" {
  family                   = "${var.name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name  = "app"
    image = var.image                       # ✅ 외부에서 이미지 주입
    portMappings = [{
      containerPort = var.container_port    # ✅ 외부에서 포트 주입
      protocol      = "tcp"
    }]
  }])
}

resource "aws_ecs_service" "service" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.sg_id]                   # ✅ ALB SG → ECS SG로 수정
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = "app"
    container_port   = var.container_port
  }

  depends_on = [aws_ecs_task_definition.task]
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.name}-cluster"
}
