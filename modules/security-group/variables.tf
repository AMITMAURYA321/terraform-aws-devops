variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ingress_rules" {
  description = "Inbound traffic rules"

  type = map(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    security_groups = optional(list(string), [])
  }))
}

variable "egress_rules" {
  description = "Outbound traffic rules"

  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}