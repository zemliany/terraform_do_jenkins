//general_variables
variable "do_token" {
    default=""
}
variable "ssh_id" {
    default=""
}

//do_variables
variable "instance_count" {}
variable "image" {
    default=   
}
variable "region" {
    default="fra1"
}
variable "my_key" {
    default=
}
variable "p_networking" {
    default=true
}
variable "droplet_name" {
    type="list"
    default = ["jenkins-master", "jenkins-rig-slave"]
}
variable "size" {
    type="list"
    default = ["2gb", "1gb"]
}