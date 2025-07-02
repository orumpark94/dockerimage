output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "service_name" {
  value = aws_ecs_service.service.name
}

output "log_group_name" {
  value = "/ecs/${aws_ecs_cluster.cluster.name}"   # 문자열 형태로 출력만 함
}

