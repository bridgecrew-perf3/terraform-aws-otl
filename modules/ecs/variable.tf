variable "image" {
  type        = string
  default     = "dockerpie.querypie.com/chequer.io/querypie-app:latest"
  description = "querypie image tag"
}

variable "vpc_id" {
  default     = null
  description = "a deployed vpc id"
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

variable "proxy_url" {
  type    = string
  default = null
  validation {
    condition     =  var.proxy_url != null
    error_message = "Make sure your input value, the conditions satisfied."
  }
}

variable "task_execute_role_arn" {
  type = string
  default = null
  validation {
    condition     = var.task_execute_role_arn != null
    error_message = "Make sure your input value, the conditions satisfied."
  }
}

variable "image_pull_secret_arn" {
  type = string
  default =  null
  validation {
    condition = var.image_pull_secret_arn != null
    error_message = "Make sure your input value, the conditions satisfied."
  }
}

variable "cluster_id" {
  type    = string
  default = null
  validation {
    condition     = var.cluster_id != null
    error_message = "Make sure your input value, the conditions satisfied."
  }
}

variable "cpu" {
  type    = number
  default = 2048
}

variable "memory" {
  type    = number
  default = 4096
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