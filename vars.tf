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

variable "sg_db_ingress" {
  type = map(object({
    port     = number
    protocol = string
    self     = bool
  }))
  default = {
    "postgresql" = {
      port     = 5432 #postgresql db port
      protocol = "tcp"
      self     = true
    }
  }
}

variable "sg_db_egress" {
  type = map(object({
    port     = number
    protocol = string
    self     = bool
  }))
  default = {
    "all" = {
      port     = 0
      protocol = "-1" # signal to every available protocol
      self     = true
    }
  }
}

variable "db_credentials" {
  type      = map(any)
  sensitive = true
  default = {
    username = "username"
    password = "password"
  }
}