output "ecs_cluster_name" {
  value       = aws_ecs_cluster.cluster.name
  description = "ECS Cluster Name"
}

output "ecs_service_name" {
  value       = aws_ecs_service.service.name
  description = "ECS Service Name"
}
