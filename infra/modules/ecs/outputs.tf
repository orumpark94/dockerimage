output "service_name" {
  description = "ECS 서비스 이름"
  value       = aws_ecs_service.service.name
}

output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}
