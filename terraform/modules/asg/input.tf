variable "asg_name" {}
variable "asg_size_min" {}
variable "asg_size_max" {}
variable "asg_size_desired" {}
variable "external_dns_name" {}
variable "internal_dns_name" {}
variable "load_balancers" {}
variable "clouddriver_profiles" {}
variable "gate_profiles" {
    default = "armory,local"
}
variable "igor_profiles" {
  default = "armory,local"
}
variable "echo_profiles" {
  default = "armory,local"
}
variable "instance_type" {}
variable "associate_public_ip_address" {}
variable "default_sg_id" {}
variable "key_name" {}
variable "s3_bucket" {}
variable "s3_prefix" {}
variable "subnet_ids" {}
variable "default_aws_region" {}
variable "instance_profile" {}
variable "mode" {}
variable "redis_primary_endpoint_address" {
    default = ""
}
variable "local_redis" {}
variable "default_iam_role" {}
variable "default_assume_role" {}
variable "ami_id" {}
variable "health_check_type" {
    default = "ELB"
}
variable "external_url_scheme" {
    default = "http"
}
variable "additional_user_data" {
    default = ""
}
variable "auth_enabled" {
    default = "false"
}
