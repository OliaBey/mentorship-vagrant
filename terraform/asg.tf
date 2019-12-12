/*
ASG
*/
resource "aws_autoscaling_group" "this" {
    name = "${local.name}"
    max_size = 1
    min_size = 0
    desired_capacity = 1
    launch_configuration = "${aws_launch_configuration.this.name}"
    vpc_zone_identifier = ["${aws_subnet.private.id}"]
    target_group_arns = ["${aws_lb_target_group.this.arn}"]
    tag {
        key = "Type"
        value = "backend"
        key = "Role"
        value = "Tomcat"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "mem_reserv_scale_down_policy" {
  name                   = "${local.name}-mem-reserv-scale-down-policy"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.this.name}"
}

resource "aws_cloudwatch_metric_alarm" "mem-reserv-scale-down-alarm" {
  alarm_name                = "${local.name}-mem-reserv-scale-down-alarm"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "MemoryReservation"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "25"
  alarm_description         = "This metric monitors ec2 memory reservation"
  alarm_actions             = ["${aws_autoscaling_policy.mem_reserv_scale_down_policy.arn}"]
}

resource "aws_autoscaling_policy" "mem_reserv_scale_up_policy" {
  name                   = "${local.name}-mem-reserv-scale-up-policy"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.this.name}"
}

resource "aws_cloudwatch_metric_alarm" "mem-reserv-scale-up-alarm" {
  alarm_name                = "${local.name}-mem-reserv-scale-up-alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "MemoryReservation"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "75"
  alarm_description         = "This metric monitors ec2 memory reservation"
  alarm_actions             = ["${aws_autoscaling_policy.mem_reserv_scale_up_policy.arn}"]
}

resource "aws_launch_configuration" "this" {
    name = "${local.name}"
    image_id = "${var.image_id}"
    instance_type = "${var.instance_type}"
    security_groups = ["${aws_security_group.asg_security_group.id}"]
    iam_instance_profile = "${aws_iam_instance_profile.this.name}"
    key_name = "${var.key_name}"
}


resource "aws_iam_instance_profile" "this" {
  name = "${local.name}"
  role = "${aws_iam_role.this.name}"
}


resource "aws_iam_role" "this" {
  name = "${local.name}"
  assume_role_policy = "${data.aws_iam_policy_document.this.json}"
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "cloudwatch.amazonaws.com",
        ]
    }
  }
}

### ECS ASG Security Group
resource "aws_security_group" "asg_security_group" {
  name     = "${local.name}-asg"
  vpc_id   = "${aws_vpc.main.id}"
}

### ECS ASG Security Group :: Allow engress connection to ALL
resource "aws_security_group_rule" "asg_egress_all" {
  security_group_id = "${aws_security_group.asg_security_group.id}"
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
}
/*
resource "aws_security_group_rule" "asg_ingress_80" {
  security_group_id = "${aws_security_group.asg_security_group.id}"
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "HTTP"
  cidr_blocks       = ["10.0.0.0/16"]
}
*/
resource "aws_security_group_rule" "asg_ingress_22" {
  security_group_id = "${aws_security_group.asg_security_group.id}"
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
}

/* EOF */