
module "provider" {
    source = "../modules/provider"
    aws_region = "${var.aws_region}"
}

module "default-sg" {
    source = "../modules/sg"
    vpc_id = "${var.vpc_id}"
    sg_name = "${var.armoryspinnaker_default_sg_name}"
}

module "managing-roles" {
    source = "../modules/managing-roles"
    instance_profile_name = "${var.armoryspinnaker_instance_profile_name}"
    managed_profile_name = "${var.armoryspinnaker_managed_profile_name}"
    access_policy_name = "${var.armoryspinnaker_access_policy_name}"
    init_policy_name = "${var.armoryspinnaker_init_policy_name}"
    packer_policy_name = "${var.armoryspinnaker_packer_policy_name}"
    assume_policy_name = "${var.armoryspinnaker_assume_policy_name}"
    s3_access_policy_name = "${var.armoryspinnaker_s3_access_policy_name}"
    s3_bucket = "${var.s3_bucket}"
}

#
# Instances / Replication
#

module "asg-standalone" {
  source = "../modules/asg"
  ami_id = "${lookup(var.armoryspinnaker_ami, var.aws_region)}"
  asg_name = "${var.armoryspinnaker_asg_standalone}"
  asg_size_min = 1
  asg_size_max = 1
  asg_size_desired = 1
  load_balancers = "${var.armoryspinnaker_external_elb_name}"
  instance_type = "${var.instance_type}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  default_sg_id = "${module.default-sg.id}"
  key_name = "${var.key_name}"
  instance_profile = "${var.armoryspinnaker_instance_profile_name}"
  subnet_ids = "${var.armoryspinnaker_subnet_ids}"

  # User-data info:
  mode = "standalone"
  default_iam_role = "${var.armoryspinnaker_instance_profile_name}"
  default_assume_role = "${var.armoryspinnaker_managed_profile_name}"
  clouddriver_profiles = "armory,local"
  internal_dns_name = ""
  external_dns_name = "${module.external-elb.dns_name}"
  local_redis = "true"
  redis_primary_endpoint_address = ""
  s3_bucket = "${var.s3_bucket}"
  s3_prefix = "${var.s3_prefix}"
  default_aws_region = "${var.aws_region}"
}

#
# Load Balancing
#

module "external-elb" {
    source = "../modules/external-elb"
    elb_name = "${var.armoryspinnaker_external_elb_name}"
    vpc_id = "${var.vpc_id}"
    subnet_ids = "${var.armoryspinnaker_subnet_ids}"
    default_sg_id = "${module.default-sg.id}"
    external_sg_name = "${var.armoryspinnaker_external_sg_name}"
}

#
# Output
#

output "SPINNAKER_DNS_NAME" {
  value = "${module.external-elb.dns_name}"
}
