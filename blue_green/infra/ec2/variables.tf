variable "ami_id" {}
variable "instance_type" {}
variable "subnets" {}

variable "alb_green_target" {
  description = "alb_green_target"
  type        = string
}
variable "alb_blue_target" {
  description = "alb_blue_target"
  type        = string
}
