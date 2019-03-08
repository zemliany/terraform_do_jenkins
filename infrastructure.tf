resource "digitalocean_droplet" "do-droplets" {
  count = "${var.instance_count}"
  image  = "${var.image}"
  name   = "${count.index == "0" ? var.droplet_name[0] : "${var.droplet_name[1]}-${count.index}"}" 
  region = "${var.region}"
  size   = "${count.index == "0" ? var.size[0] : "${var.size[1]}"}" 
  private_networking = "${var.p_networking}"
  ssh_keys = "${var.my_key}"

connection {
    type = "ssh"
    user = "root"
    //private_key = "${file("/home/zemlyanoy/.ssh/id_rsa")}"
    private_key = "${file(var.ssh_id)}"
}

provisioner "remote-exec" {
    inline = [
      "sleep 10",  
      "sudo apt-get update -y",
      "sudo apt-get install python2.7 -y"
    ]
    
    }
}
