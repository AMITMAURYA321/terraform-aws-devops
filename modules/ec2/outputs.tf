output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address of EC2"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP address of EC2"
  value       = aws_instance.this.private_ip
}

output "ami_id" {
  description = "AMI ID used by EC2"
  value       = aws_instance.this.ami
}