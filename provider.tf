provider "digitalocean" {
  token = "${chomp(file(var.do_token))}"
}
