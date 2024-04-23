variable "token" {
  description = "The Linode API token"
  type        = string
}

variable "instance_password" {
  description = "password for the instance"
  type        = string
}

variable "db_password" {
  description = "password for the database"
  type        = string
}

variable "environment" {
  description = "environment"
}

variable "project_name" {
  description = "project name"
}
