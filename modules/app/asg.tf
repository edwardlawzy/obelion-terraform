resource "aws_autoscaling_group" "wordpress_asg" {
  name                      = "${var.project_name}-asg"
  vpc_zone_identifier       = var.public_subnet_ids
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_capacity
  min_size                  = var.min_capacity
  health_check_type         = "EC2"
  force_delete              = true

  target_group_arns = [aws_lb_target_group.alb-tg.arn]

  launch_template {
    id      = aws_launch_template.wordpress_lt.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "cpu_scale_out" {
  name                   = "cpu-scale-out"
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = var.asg_cooldown
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-asg-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.asg_threshold # CPU reaches 50%
  alarm_description   = "Scale out when ASG CPU average is > 50%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.cpu_scale_out.arn]
}
