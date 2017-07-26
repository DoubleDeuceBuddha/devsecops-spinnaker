
module "provider" {
    source = "../modules/provider"
    aws_region = "${var.aws_region}"
}

module "default-sg" {
    source = "../modules/sg"
    vpc_id = "${var.vpc_id}"
    sg_name = "${var.armoryspinnaker_default_sg_name}"
}

#module "redis" {
#    use_existing_cache = "false"
#    source = "../modules/redis"
#    cache_subnet_name = "${var.armoryspinnaker_cache_subnet_name}"
#    subnet_ids = "${var.armoryspinnaker_subnet_ids}"
#    cache_name = "${var.armoryspinnaker_cache_name}"
#    default_sg_id = "${module.default-sg.id}"
#}

#
# Instances / Replication
#

module "asg" {
  source = "../modules/asg"
  ami_id = "${lookup(var.armoryspinnaker_ami, var.aws_region)}"
  asg_name = "${var.armoryspinnaker_asg}"
  asg_size_min = 1
  asg_size_max = 1
  asg_size_desired = 1
  load_balancers = "${var.armoryspinnaker_external_elb_name},${var.armoryspinnaker_internal_elb_name}"
  instance_type = "${var.instance_type}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  default_sg_id = "${module.default-sg.id}"
  key_name = "${var.key_name}"
  instance_profile = "${var.armoryspinnaker_instance_profile_name}"
  subnet_ids = "${var.armoryspinnaker_subnet_ids}"
  health_check_type = "EC2"

  # User-data info:
  mode = "ha"
  auth_enabled = "true"
  default_iam_role = "${var.armoryspinnaker_instance_profile_name}"
  default_assume_role = "${var.armoryspinnaker_managed_profile_name}"
  clouddriver_profiles = "armory,local"
  gate_profiles = "armory,local,githubOAuth"
  internal_dns_name = "${aws_elb.armoryspinnaker_internal.dns_name}"
  external_dns_name = "${var.dns_name}"
  external_url_scheme = "https"
  local_redis = "true"
  #redis_primary_endpoint_address = "${module.redis.primary_endpoint_address}"
  s3_bucket = "${var.s3_bucket}"
  s3_prefix = "${var.s3_prefix}"
  default_aws_region = "${var.aws_region}"
  additional_user_data = "${var.additional_user_data}"
}

#
# Load Balancing
#

resource "aws_elb" "armoryspinnaker_external" {
  name = "${var.armoryspinnaker_external_elb_name}"
  subnets = ["${split(",", var.armoryspinnaker_subnet_ids)}"]
  security_groups = ["${module.default-sg.id}", "sg-622f0319"] # sg-622f0319 = all_office

  listener {
    instance_port     = 9000
    instance_protocol = "http"
    lb_port           = 9000
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  listener {
    instance_port     = 9000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  listener {
    instance_port     = 9000
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  listener {
    instance_port     = 8084
    instance_protocol = "http"
    lb_port           = 8084
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  listener {
    instance_port     = 7002
    instance_protocol = "http"
    lb_port           = 7002
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  listener {
    instance_port     = 7003
    instance_protocol = "http"
    lb_port           = 7003
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  listener {
    instance_port     = 8089
    instance_protocol = "http"
    lb_port           = 8089
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  listener {
    instance_port     = 8088
    instance_protocol = "http"
    lb_port           = 8088
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  listener {
    instance_port     = 8083
    instance_protocol = "http"
    lb_port           = 8083
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  listener {
    instance_port     = 8087
    instance_protocol = "http"
    lb_port           = 8087
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  listener {
    instance_port     = 5000
    instance_protocol = "http"
    lb_port           = 5000
    lb_protocol       = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:515116089304:certificate/44c5bde6-f8c2-4d66-ae9c-0bdc1fda598d" # *.dev.armory.io cert
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 3
    target              = "HTTP:5000/versions"
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

resource "aws_elb" "armoryspinnaker_internal" {
  name = "${var.armoryspinnaker_internal_elb_name}"
  subnets = ["${split(",", var.armoryspinnaker_subnet_ids)}"]
  internal = true
  security_groups = [
    "${module.default-sg.id}"
  ]

  listener {
    instance_port     = 5000
    instance_protocol = "http"
    lb_port           = 5000
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 9000
    instance_protocol = "http"
    lb_port           = 9000
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8084
    instance_protocol = "http"
    lb_port           = 8084
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 7002
    instance_protocol = "http"
    lb_port           = 7002
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 7003
    instance_protocol = "http"
    lb_port           = 7003
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8089
    instance_protocol = "http"
    lb_port           = 8089
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8088
    instance_protocol = "http"
    lb_port           = 8088
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8083
    instance_protocol = "http"
    lb_port           = 8083
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8087
    instance_protocol = "http"
    lb_port           = 8087
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 3
    target              = "HTTP:5000/versions"
    interval            = 5
  }
}

#
# Output
#

output "SPINNAKER_DNS_NAME" {
  value = "${aws_elb.armoryspinnaker_external.dns_name}"
}

output "DEFAULT_SECURITY_GROUP" {
  value = "${module.default-sg.id}"
}

output "USER_DATA" {
  value = "${module.asg.user_data}"
}