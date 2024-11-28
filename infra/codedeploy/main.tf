resource "aws_codedeploy_app" "app" {
  name = "python-app"
}

resource "aws_codedeploy_deployment_group" "group" {
  app_name = aws_codedeploy_app.app.name
  deployment_group_name = "python-app-group"

  service_role_arn = var.iam_role

  deployment_style {
    deployment_type = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = var.blue_target
      }
      target_group {
        name = var.green_target
      }
      prod_traffic_route {
        listener_arns = var.alb_listner
      }
    }
  }
}
