variable "default_tags" {
  type = map(string)
  default = {
    "username" = "bvanek"
  }
  description = "This is a resource in my terraform testing environment"
}

variable "public_subnet_count" {
  type        = number
  description = "Number of public subnets in VPC"
  default     = 2
}

variable "private_subnet_count" {
  type        = number
  description = "Number of private subnets in VPC"
  default     = 2
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR for VPC"
}