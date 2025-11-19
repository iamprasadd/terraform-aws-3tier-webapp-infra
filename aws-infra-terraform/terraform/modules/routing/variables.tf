variable "vpc_id" {
  type = string
}
variable "project" {
  type = string
}
variable "igw_id" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "app_subnet_ids" {
  type = list(string)
}
variable "data_subnet_ids" {
  type = list(string)
}