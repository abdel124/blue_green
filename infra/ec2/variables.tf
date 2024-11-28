variable "ami_id" {}
variable "instance_type" {}
variable "subnets" {}

variable "alb_green_target" {
  description = "alb_green_target"
  type        = string
 # default = "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"
}
variable "alb_blue_target" {
  description = "alb_blue_target"
  type        = string
 # default = "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"
}
