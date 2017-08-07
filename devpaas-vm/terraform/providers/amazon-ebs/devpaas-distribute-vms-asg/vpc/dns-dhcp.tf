resource "aws_route53_zone" "mm_devpaas_dns_primary" {
  name = "marmac-labs.name"

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"
}

resource "aws_vpc_dhcp_options" "mm_devpaas_vpc_dhcp_options" {

  domain_name = "${aws_route53_zone.mm_devpaas_dns_primary.name}"
  domain_name_servers = ["AmazonProvidedDNS"]

  //domain_name_servers = ["10.0.0.2"]

  tags {
    Name = "${var.project_name}-DHCP-OPTIONS"
  }
}


resource "aws_vpc_dhcp_options_association" "mm_devpaas_vpc_dhcp_options_association" {

  dhcp_options_id = "${aws_vpc_dhcp_options.mm_devpaas_vpc_dhcp_options.id}"
  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

}