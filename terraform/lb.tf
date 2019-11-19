/*
    LoadBalancer
*/

resource "aws_security_group" "lb" {
  name        = "${local.name}"
  description = "${local.name}"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "lb_ingress" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "HTTP"
  security_group_id = "${aws_security_group.lb.id}"
}
resource "aws_security_group_rule" "lb_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.lb.id}"
}

resource "aws_lb" "this" {
  name                       = "${local.name}"
  subnets                    = ["${aws_subnet.private.id}"]
  security_groups            = ["${aws_security_group.lb.id}"]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "this" {
  name   = "${local.name}-target-group"
  vpc_id   = "${aws_vpc.main.id}"
  protocol             = "HTTP"
  port                 = 80
  deregistration_delay = 0
  target_type          = "ip"

  health_check {
    protocol = "HTTP"
    path = "/"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = "${aws_lb.this.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.this.arn}"
    type             = "forward"
  }
}
/*

*/

### EOF