output "instance_public_ip" {
  description = " Public IP of Wordpress-EC2"
  value       = aws_instance.wordpress.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of Wordpress-EC2"
  value       = aws_instance.wordpress.public_dns
}

output "rds_endpoint" {
  description = "Endpoint of the RDS MySQL database"
  value       = aws_db_instance.wordpress.address
}