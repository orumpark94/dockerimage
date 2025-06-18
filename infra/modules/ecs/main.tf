resource "aws_ecs_task_definition" "task" {
  family                   = "${var.name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name  = "app"
    image = "baram940/devops-test:1.0"
    portMappings = [{
      containerPort = 3000
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
    subnets         = [var.private_subnet_id]
    security_groups = [var.alb_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = "app"
    container_port   = 3000
  }

  depends_on = [aws_ecs_task_definition.task]
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.name}-cluster"
}
