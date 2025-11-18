variable "region" {
  type = string
}
variable "profile" {
  type = string
}
variable "project" {
  type = string
}
variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)

}
variable "public_subnets" {
  type = list(string)
}
variable "app_subnets" {
  type = list(string)
}
variable "data_subnets" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "key_name" {
  type    = string
  default = null
}
variable "min_size" {
  type    = number
  default = 1
}
variable "max_size" {
  type    = number
  default = 2
}
variable "desired_size" {
  type    = number
  default = 1
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type      = string
  sensitive = true
}

