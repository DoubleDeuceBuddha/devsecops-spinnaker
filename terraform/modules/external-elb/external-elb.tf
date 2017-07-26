
resource "aws_elb" "armoryspinnaker_external" {
  name = "${var.elb_name}"
  subnets = ["${split(",", var.subnet_ids)}"]
  security_groups = ["${list(var.default_sg_id, aws_security_group.armoryspinnaker_external.id)}"]

  listener {
    instance_port     = 9000
    instance_protocol = "http"
    lb_port           = 9000
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 9000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8084
    instance_protocol = "http"
    lb_port           = 8084
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 5000
    instance_protocol = "http"
    lb_port           = 5000
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 3
    target              = "HTTP:5000/healthcheck"
    interval            = 5
  }
}

resource "aws_lb_cookie_stickiness_policy" "gate_sticky" {
      name = "gate-sticky-policy"
      load_balancer = "${aws_elb.armoryspinnaker_external.id}"
      lb_port = 8084
}

resource "aws_lb_cookie_stickiness_policy" "deck_sticky" {
      name = "deck-sticky-policy"
      load_balancer = "${aws_elb.armoryspinnaker_external.id}"
      lb_port = 9000
}

resource "aws_security_group" "armoryspinnaker_external" {
  vpc_id = "${var.vpc_id}"
  name = "${var.external_sg_name}"
  description = "Allows web traffic to the dashboard and gate."

  ingress {
      from_port = 9000
      to_port = 9000
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 8084
      to_port = 8084
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 5000
      to_port = 5000
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.external_sg_name}"
  }
}
