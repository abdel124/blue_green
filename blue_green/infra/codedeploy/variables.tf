variable "iam_role" {}

variable "blue_target" {
  description = "blue_target "
  type        = string
  #default     = "main"
}
variable "green_target" {
  description = "green_target"
  type        = string
  #default     = "main"
}
variable "alb_listner" {
  description = "load balancer listner"
  type        = list(string)
  #default     = "main"
}

variable "alb_name" {
  description = "load balancer listner"
  type        = string
  #default     = "main"
}
