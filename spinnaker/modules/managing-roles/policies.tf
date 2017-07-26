
#
# Spinnaker Managed and Managing Accounts:
#

resource "aws_iam_policy" "SpinnakerPackerPolicy" {
    name = "${var.packer_policy_name}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Effect": "Allow",
      "Action" : [
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CopyImage",
        "ec2:CreateImage",
        "ec2:CreateKeypair",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteKeypair",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSnapshot",
        "ec2:DeleteVolume",
        "ec2:DeregisterImage",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeImages",
        "ec2:DescribeInstances",
        "ec2:DescribeRegions",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:GetPasswordData",
        "ec2:ModifyImageAttribute",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifySnapshotAttribute",
        "ec2:RegisterImage",
        "ec2:RunInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource" : "*"
  }]
}
EOF
}

resource "aws_iam_policy" "SpinnakerInitializationPolicy" {
    name = "${var.init_policy_name}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeRegions",
                "ec2:DescribeAvailabilityZones"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "SpinnakerAccessPolicy" {
    name = "${var.access_policy_name}"
    policy = "${file("${path.module}/SpinnakerAccessPolicy.json")}"
}

resource "aws_iam_policy" "SpinnakerAssumeRolePolicy" {
    name = "${var.assume_policy_name}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Resource": [
        "${aws_iam_role.SpinnakerManagedProfile.arn}"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "SpinnakerS3AccessPolicy" {
  name = "${var.s3_access_policy_name}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket}*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "SpinnakerInstanceProfile" {
    name = "${var.instance_profile_name}"
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

resource "aws_iam_instance_profile" "SpinnakerInstanceProfile" {
    name = "${var.instance_profile_name}"
    roles = ["${aws_iam_role.SpinnakerInstanceProfile.name}"]
}

resource "aws_iam_role_policy_attachment" "SpinnakerInitAttachment" {
    role = "${aws_iam_role.SpinnakerInstanceProfile.name}"
    policy_arn = "${aws_iam_policy.SpinnakerInitializationPolicy.arn}"
}

resource "aws_iam_role_policy_attachment" "SpinnakerPackerAttachment" {
    role = "${aws_iam_role.SpinnakerInstanceProfile.name}"
    policy_arn = "${aws_iam_policy.SpinnakerPackerPolicy.arn}"
}

resource "aws_iam_role_policy_attachment" "SpinnakerAssumeRoleAttachment" {
    role = "${aws_iam_role.SpinnakerInstanceProfile.name}"
    policy_arn = "${aws_iam_policy.SpinnakerAssumeRolePolicy.arn}"
}

resource "aws_iam_role_policy_attachment" "SpinnakerS3AccessAttachment" {
    role = "${aws_iam_role.SpinnakerInstanceProfile.name}"
    policy_arn = "${aws_iam_policy.SpinnakerS3AccessPolicy.arn}"
}

resource "aws_iam_role" "SpinnakerManagedProfile" {
    name = "${var.managed_profile_name}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.SpinnakerInstanceProfile.arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "SpinnakerManagedAccessAttachment" {
    role = "${aws_iam_role.SpinnakerManagedProfile.name}"
    policy_arn = "${aws_iam_policy.SpinnakerAccessPolicy.arn}"
}

