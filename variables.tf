variable "name" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "ecr_create" {
  type    = bool
  default = true
}

variable "ecr_scan_on_push" {
  type    = bool
  default = true
}

variable "ecr_number_of_images_to_keep" {
  type    = number
  default = 30
}

variable "annotations" {
  type    = map(any)
  default = {}
}
variable "command" {
  type = list(string)
}

variable "image" {
  type    = string
  default = "dummy"
}

variable "labels" {
  type    = map(any)
  default = {}
}

variable "namespace" {
  type = string
}

variable "replicas" {
  type    = number
  default = 1
}

variable "svc_create" {
  type    = bool
  default = true
}

variable "svc_port" {
  type = number
}

variable "svc_protocol" {
  type    = string
  default = "TCP"
}

variable "svc_type" {
  type    = string
  default = "ClusterIP"
}

variable "wait_for_rollout" {
  type = bool
  default = false
}