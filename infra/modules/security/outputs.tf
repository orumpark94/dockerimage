output "sg_id" {
  value = aws_security_group.this.id
  description = "ID of the security group created by this module"
}
