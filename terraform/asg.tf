

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

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
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
