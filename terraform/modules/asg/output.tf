output "user_data" {
    value = "${data.template_file.armoryspinnaker_ud.rendered}"
}