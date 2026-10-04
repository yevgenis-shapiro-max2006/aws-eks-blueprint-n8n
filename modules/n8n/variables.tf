variable "postgres_password" {
  type      = string
  default = "fuko09phsurxho"
  sensitive = true
}

variable "redis_password" {
  type      = string
  default = "fuko09phsurxho"
  sensitive = true
}

variable "n8n_hostname" {
  type = string
  default = "workflow.crypterio.co"
}
