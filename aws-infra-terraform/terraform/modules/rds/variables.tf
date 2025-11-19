########################################
# modules/rds/variables.tf
########################################

variable "project" {
  type        = string
  description = "Project/name prefix"
}

variable "environment" {
  type        = string
  description = "Environment (dev/stage/prod)"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "Private/data subnets for the DB subnet group"
}

variable "db_sg_id" {
  type        = string
  description = "Security group ID for DB (allows 3306 only from app_sg)"
}

variable "engine" {
  type        = string
  description = "DB engine (mysql, postgres, etc)"
  default     = "mysql"
}

variable "engine_version" {
  type        = string
  description = "DB engine version"
  default     = "8.0"
}

variable "instance_class" {
  type        = string
  description = "RDS instance type"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Initial storage (GB)"
  default     = 20
}

variable "max_allocated_storage" {
  type        = number
  description = "Max storage for autoscaling (GB)"
  default     = 100
}

variable "db_name" {
  type        = string
  description = "Database name to create"
  default     = "appdb"
}

variable "db_username" {
  type        = string
  description = "Master username"
}

variable "db_password" {
  type        = string
  description = "Master password"
  sensitive   = true
}

variable "db_port" {
  type        = number
  description = "DB port"
  default     = 3306
}

variable "multi_az" {
  type        = bool
  description = "Whether to create Multi-AZ RDS"
  default     = false
}

variable "storage_encrypted" {
  type        = bool
  description = "Encrypt RDS storage"
  default     = true
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "backup_window" {
  type    = string
  default = "03:00-04:00"
}

variable "maintenance_window" {
  type    = string
  default = "mon:04:00-mon:05:00"
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}
