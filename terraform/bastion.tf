resource "aws_instance" "web" {
  ami           = "${var.image_id}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.bastion_security_group.id}"]
  subnet_id = "${aws_subnet.public.id}"
  associate_public_ip_address = "true"

  tags = {
    Name = "${local.name}-bastion"
  }
}

resource "aws_security_group" "bastion_security_group" {
  name     = "${local.name}-bastion"
  vpc_id   = "${aws_vpc.main.id}"
}

### ECS ASG Security Group :: Allow engress connection to ALL
resource "aws_security_group_rule" "bastion_egress_all" {
  security_group_id = "${aws_security_group.bastion_security_group.id}"
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "bastion_ingress_22" {
  security_group_id = "${aws_security_group.bastion_security_group.id}"
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
}

/* EOF */