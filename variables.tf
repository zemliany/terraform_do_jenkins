//general_variables
variable "do_token" { 
    //provide full path to file where do_token exists, e.g ~/.config/digital_ocean/do_token
    default=""  
}
variable "ssh_id" {
    //provide full path to id_rsa key to connect DigitalOcean Droplets via ssh, e.g ~/.ssh/id_rsa
    default=""
}

//do_variables
variable "instance_count" {}
variable "image" {
    //provide image_id from the list-distribution list from DigitalOcean API
    default=""   
}
variable "region" {
    //provide available region from region list from DigitalOcean API
    default=""
}
variable "my_key" {
    //provide ssh_id key from ssk-key list from DigitalOcean API
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
variable "tag" {
    type="list"
    default = ["master","rig"]
} 