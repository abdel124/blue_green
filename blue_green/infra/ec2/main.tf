resource "aws_launch_template" "blue_lc" {
  name_prefix   = "blue-lc"
  image_id      = var.ami_id       # The AMI ID to use for the instances
  instance_type = var.instance_type
  #key_name      = var.key_name     # If you're using SSH key pairs for access
  #vpc_security_group_ids = [var.sg_id]  # Security Group ID for the instance
  #user_data = data.template_file.user_data.rendered  # User data script, if required

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Environment" = "blue"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_template" "green_lc" {
  name_prefix   = "green-lc"
  image_id      = var.ami_id       # The AMI ID to use for the instances
  instance_type = var.instance_type
  #key_name      = var.key_name     # If you're using SSH key pairs for access
  #vpc_security_group_ids = [var.sg_id]  # Security Group ID for the instance
  #user_data = data.template_file.user_data.rendered  # User data script, if required

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Environment" = "blue"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "blue_asg" {
  name                      = "blue-asg"
  min_size                  = 1
  max_size                  = 2
  vpc_zone_identifier       = var.subnets
  target_group_arns         = [var.alb_blue_target]
  launch_template {
    id      = aws_launch_template.blue_lc.id
    version = "$Latest"
  }
  tag {
    key                 = "Environment"
    value               = "Blue"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "green_asg" {
  name                      = "green-asg"
  min_size                  = 1
  max_size                  = 2
  vpc_zone_identifier       = var.subnets
  target_group_arns         = [var.alb_green_target]
  launch_template {
    id      = aws_launch_template.green_lc.id
    version = "$Latest"
  }
  tag {
    key                 = "Environment"
    value               = "Green"
    propagate_at_launch = true
  }
}
