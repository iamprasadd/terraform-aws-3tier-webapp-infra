variable "project" {
  type = string
}
variable "region" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "app_subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "app_sg_id" {
  type = string
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
  type = number

}
variable "max_size" {
  type = number

}
variable "desired_size" {
  type = number

}
variable "user_data" {
  type    = string
  default = ""
}

variable "db_endpoint" {
  type    = string
  default = ""
}
variable "db_port" {
  type    = number
  default = 3306
}
variable "db_name" {
  type    = string
  default = ""
}
variable "db_username" {
  type    = string
  default = ""
}
variable "db_password" {
  type      = string
  sensitive = true
  default   = ""
}