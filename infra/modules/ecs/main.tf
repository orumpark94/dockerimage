# ✅ CloudWatch Log Group 생성 (ECS 로그용)
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.name}"
  retention_in_days = 7
}

# ✅ IAM Role (로그 전송 권한 포함)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_logs_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ✅ ECS 클러스터
resource "aws_ecs_cluster" "cluster" {
  name = "${var.name}-cluster"
}

# ✅ ECS Task Definition (Log Group 의존성 추가됨)
resource "aws_ecs_task_definition" "task" {
  family                   = "${var.name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "app"
    image = var.image
    portMappings = [{
      containerPort = var.container_port
      protocol      = "tcp"
    }],
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${var.name}"
        awslogs-region        = var.region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])

  depends_on = [aws_cloudwatch_log_group.ecs_log_group]
}

# ✅ ECS 서비스
resource "aws_ecs_service" "service" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = "app"
    container_port   = var.container_port
  }

  depends_on = [aws_ecs_task_definition.task]
}
