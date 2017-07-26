variable "armoryspinnaker_ami" {
 type = "map"
  default = {
    "us-east-1" = "ami-7e4a5868"
    "us-west-1" = "ami-c7032aa7"
    "us-west-2" = "ami-b4554dcd"
  }
}
