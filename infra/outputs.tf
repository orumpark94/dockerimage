output "alb_dns" {
  value = module.alb.alb_dns
}

output "db_sg_id" {
  description = "Security Group ID for RDS DB"
  value       = module.security_db.sg_id
}