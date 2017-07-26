
data "template_file" "armoryspinnaker_ud" {
  template = <<EOF
#!/bin/bash
# wait for other services to come up
echo "Sleeping for 20 seconds before executing scripts..."
sleep 20

cat <<EOT > /etc/default/armory-spinnaker
#!/bin/bash
# Used to determine what services to start on the instance.
export ARMORY_SPINNAKER_MODE=$${mode}
export LOCAL_REDIS=$${local_redis}
EOT

cat <<EOT > /opt/spinnaker/env/default.env
# Used by Spinnaker/front50 to persist pipelines:
ARMORYSPINNAKER_S3_BUCKET=$${s3_bucket}
ARMORYSPINNAKER_S3_PREFIX=$${s3_prefix}
SPINNAKER_AWS_DEFAULT_REGION=$${default_aws_region}

# Used by the Spinnaker AWS Provider:
SPINNAKER_AWS_DEFAULT_IAM_ROLE=$${default_iam_role}
SPINNAKER_AWS_DEFAULT_ASSUME_ROLE=$${default_assume_role}

# Used by Gate and/or Deck:
API_HOST=$${external_url_scheme}://$${external_dns_name}:8084
DECK_HOST=$${external_url_scheme}://$${external_dns_name}
AUTH_ENABLED=$${auth_enabled}
GATE_SSL_ENABLED=false
GATE_X509_ENABLED=false

# Binds all spring servers to all addresses
SERVER_ADDRESS=0.0.0.0
# Used by the Spinnaker subservices:
$${default_dns_name}
SPRING_CONFIG_LOCATION=/opt/spinnaker/config/
LOCAL_REDIS=$${local_redis}
REDIS_HOST=$${redis_host}
SPRING_PROFILES_ACTIVE=armory,local
LOGGING_PROFILE=default
CLOUDDRIVER_OPTS="-Dspring.profiles.active=$${clouddriver_profiles}"
GATE_OPTS="-Dspring.profiles.active=$${gate_profiles}"
IGOR_OPTS="-Dspring.profiles.active=$${igor_profiles}"
ECHO_OPTS="-Dspring.profiles.active=$${echo_profiles}"
EOT

$${additional_user_data}

service armory-spinnaker restart
EOF

  vars {
    default_aws_region      = "${var.default_aws_region}"
    s3_bucket               = "${var.s3_bucket}"
    s3_prefix               = "${var.s3_prefix}"
    default_dns_name        = "${var.internal_dns_name != "" ? "DEFAULT_DNS_NAME=${var.internal_dns_name}" : ""}"
    external_dns_name       = "${var.external_dns_name}"
    external_url_scheme     = "${var.external_url_scheme}"
    clouddriver_profiles    = "${var.clouddriver_profiles}"
    gate_profiles           = "${var.gate_profiles}"
    igor_profiles           = "${var.igor_profiles}"
    echo_profiles           = "${var.echo_profiles}"
    local_redis             = "${var.local_redis}"
    redis_host              = "${var.local_redis == "true" ? "redis" : var.redis_primary_endpoint_address}"
    mode                    = "${var.mode}"
    default_iam_role        = "${var.default_iam_role}"
    default_assume_role     = "${var.default_assume_role}"
    additional_user_data    = "${var.additional_user_data}"
    auth_enabled            = "${var.auth_enabled}"
  }
}

resource "aws_launch_configuration" "lc" {
  image_id              = "${var.ami_id}"
  instance_type         = "${var.instance_type}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  iam_instance_profile  = "${var.instance_profile}"
  security_groups       = ["${var.default_sg_id}"]
  user_data             = "${data.template_file.armoryspinnaker_ud.rendered}"
  key_name              = "${var.key_name}"

  lifecycle {
     create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "armory-spinnaker-asg" {
  name                      = "${var.asg_name}"
  max_size                  = "${var.asg_size_max}"
  min_size                  = "${var.asg_size_min}"
  desired_capacity          = "${var.asg_size_desired}"
  force_delete              = true
  health_check_grace_period = 300
  health_check_type         = "${var.health_check_type}"
  launch_configuration      = "${aws_launch_configuration.lc.name}"
  load_balancers            = ["${split(",", var.load_balancers)}"]
  vpc_zone_identifier       = ["${split(",", var.subnet_ids)}"]

  tag {
    key                 = "Name"
    value               = "armoryspinnaker"
    propagate_at_launch = "true"
  }
}
