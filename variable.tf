variable "type" {
  type        = string
  default     = null
  description = ""
}

variable "vpc_id" {
  default     = null
  description = "a deployed vpc id"
}

variable "cluster_id" {
  default     = null
  description = "targeted ecs cluster id"
}

variable "subnet_ids" {
  type        = list(string)
  default     = null
  description = "a deployed subnet ids, it must be attached vpc_id"
}

variable "security_group_ids" {
  type        = list(string)
  default     = null
  description = "attached security_group at querypie proxy"
}

variable "cpu" {
  type        = number
  description = "container limitation of cpu"
  default     = 2048
}

variable "memory" {
  type        = number
  description = "container limitation of memory"
  default     = 4096
}

variable "proxy_url" {
  type    = string
  default = null
  validation {
    condition     = var.proxy_url != null
    error_message = "Make sure your input value, the conditions satisfied."
  }
}

variable "image" {
  type        = string
  default     = "dockerpie.querypie.com/chequer.io/querypie-app:latest"
  description = "querypie middleware container image"
}

variable "image_pull_secret_arn" {
  type    = string
  default = null
  validation {
    condition     = var.image_pull_secret_arn != null
    error_message = "Make sure your input value, the conditions satisfied."
  }
}

variable "task_execute_role_arn" {
  type    = string
  default = null
  validation {
    condition     = var.task_execute_role_arn != null
    error_message = "Make sure your input value, the conditions satisfied."
  }
}

variable "otl_server_listening_port" {
  type        = number
  default     = 6000
  description = "server listening port, that served rest api"
}

variable "otl_server_tunneling_port" {
  type        = number
  default     = 7000
  description = "server tunneling port, that will be connect otl client"
}