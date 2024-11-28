resource "aws_launch_configuration" "blue_lc" {
  name          = "blue-lc"
  image_id      = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "green_lc" {
  name          = "green-lc"
  image_id      = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "blue_asg" {
  name                      = "blue-asg"
  launch_configuration      = aws_launch_configuration.blue_lc.id
  min_size                  = 1
  max_size                  = 2
  vpc_zone_identifier       = var.subnets
  target_group_arns         = [var.alb_blue_target]

  tag {
    key                 = "Environment"
    value               = "Blue"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "green_asg" {
  name                      = "green-asg"
  launch_configuration      = aws_launch_configuration.green_lc.id
  min_size                  = 1
  max_size                  = 2
  vpc_zone_identifier       = var.subnets
  target_group_arns         = [var.alb_green_target]

  tag {
    key                 = "Environment"
    value               = "Green"
    propagate_at_launch = true
  }
}
