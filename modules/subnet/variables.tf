variable "vpc_id" {
  description = "ID of the VPC where subnets will be created"
  type        = string
}

variable "environment" {
  description = "Environment name such as dev or prod"
  type        = string
}

variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
}

variable "public_route_table_id" {
  description = "ID of the public route table"
  type        = string
}