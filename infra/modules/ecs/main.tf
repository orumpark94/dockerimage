# ✅ CloudWatch Log Group 생성 (ECS 로그용)
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.name}"
  retention_in_days = 7
}

# ✅ IAM Role (로그 전송 권한 포함) → [기존 구성 유지]
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

# ✅ 현재 계정 정보 조회 (account_id 사용) → [🔧 새로 추가됨]
data "aws_caller_identity" "current" {}

# ✅ Task Role (SSM 접근을 위한 IAM Role) → [🔧 새로 추가됨]
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# ✅ Task Role에 SSM 읽기 권한 부여 → [🔧 새로 추가됨]
resource "aws_iam_policy" "ssm_read_policy" {
  name = "${var.name}-ssm-read-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters"
      ],
      Resource = [
        "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/app/DB_*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ssm_read_policy.arn
}

# ✅ ECS Task Definition
resource "aws_ecs_task_definition" "task" {
  family                   = "${var.name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn        # 로그용 Role
  task_role_arn      = aws_iam_role.ecs_task_role.arn                  # 🔧 SSM 접근용 Role

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