
#
# Location
#

variable "aws_region" {
  description = "The region in which you want Spinnaker to live."
}

variable "vpc_id" {
  description = "The VPC in which you want Spinnaker to live."
}

variable "armoryspinnaker_subnet_ids" {
  description = "The subnets in which you want Spinnaker to live."
}

variable "s3_bucket" {
  description = "S3 Bucket to persist Spinnaker's state."
}

variable "s3_prefix" {
  description = "Within the previously specified S3 bucket, this is the prefix to use for persisting Spinnaker's state."
  default = "armoryspinnaker"
}

#
# Roles / Policies
#

variable "armoryspinnaker_assume_policy_name" {
  description = "The name of the assume policy you want spinnaker to use"
  default = "SpinnakerAssumePolicy"
}

variable "armoryspinnaker_instance_profile_name" {
  description = "The name of the role you want to use for the Spinnaker instance"
  default = "SpinnakerInstanceProfile"
}

variable "armoryspinnaker_managed_profile_name" {
  description = "The name of the managed role you want Spinnaker to manage"
  default = "SpinnakerManagedProfile"
}

variable "armoryspinnaker_access_policy_name" {
  description = "The name of the access policy you want Spinnaker to have"
  default = "SpinnakerAccessPolicy"
}

variable "armoryspinnaker_init_policy_name" {
  description = "The name of the initialzation policy you want Spinnaker hosts to use"
  default = "SpinnakerInitPolicy"
}

variable "armoryspinnaker_s3_access_policy_name" {
  description = "By default Spinnaker uses S3 as it's backing store for pipelines & applications data and requires a policy"
  default = "SpinnakerS3AccessPolicy"
}

variable "armoryspinnaker_packer_policy_name" {
  description = "The name of the access policy for Packer"
  default = "SpinnakerPackerPolicy"
}

#
# Load Balancing
#

variable "armoryspinnaker_external_elb_name" {
  description = "The name of the ELB that users will use"
  default = "armoryspinnaker-external"
}

#
# Security
#

variable "armoryspinnaker_external_sg_name" {
  description = "The name of the security group to give to allow web traffic to the dashboard"
  default = "armoryspinnaker-external"
}

variable "armoryspinnaker_default_sg_name" {
  description = "The name of the default security group that allows Spinnaker sub-services to communicate"
  default = "armoryspinnaker-default"
}

variable "associate_public_ip_address" {
  description = "Wether or not the spinnaker instance itself has a public ip, defaults to false"
  default = "false"
}

variable "shared_credentials_file" {
  description = "The path of the shared credentials file to be used, default ~/.aws/credentials"
  default = "~/.aws/credentials"
}

variable "key_name" {
  description = "An already existing AWS key pair which will be used to secure the EC2 instances."
}

#
# Instances / Replication
#

variable "armoryspinnaker_asg_standalone" {
  default = "armoryspinnaker-standalone-v000"
}

variable "instance_type" {
  description = "The instance type in which you want Spinnaker to live."
  default = "m3.2xlarge"
}
