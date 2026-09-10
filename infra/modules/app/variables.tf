variable "app_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "image" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "health_path" {
  type    = string
  default = "/"
}

variable "ingress_host" {
  type = string
}

variable "replica_count" {
  type    = number
  default = 2
}

variable "cpu_request" {
  type    = string
  default = "100m"
}

variable "memory_request" {
  type    = string
  default = "128Mi"
}

variable "cpu_limit" {
  type    = string
  default = "250m"
}

variable "memory_limit" {
  type    = string
  default = "256Mi"
}
