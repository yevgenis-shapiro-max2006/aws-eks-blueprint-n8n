
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

variable "n8n_encryption_key" {
  type      = string
  default = "46280e60142afeb0f39dac830cf29f25187add0e23f10235ad640f60ee105fcc"
  sensitive = true
}

variable "n8n_hostname" {
  type = string
  default = "workflow.crypterio.co"
}
