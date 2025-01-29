# modules/ec2/outputs.tf
output "instance_id" {
  value = aws_instance.app.id
}

output "security_group_id" {
  value = aws_security_group.ec2.id
}

output "public_ip" {
  value = aws_instance.app.public_ip
}