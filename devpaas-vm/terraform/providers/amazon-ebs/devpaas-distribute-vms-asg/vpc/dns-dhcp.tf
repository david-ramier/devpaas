resource "aws_route53_zone" "mm_devpaas_dns_primary_fw" {

  name = "${var.primary_zone_domain_name}"

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "${var.project_name}-DNS-PRIMARY-FORWARD-ZONE"
  }
}

resource "aws_route53_zone" "mm_devpaas_dns_primary_rv" {
  name = "0.10.in-addr.arpa"

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "${var.project_name}-DNS-PRIMARY-REVERSE-ZONE"
  }
}

resource "aws_vpc_dhcp_options" "mm_devpaas_vpc_dhcp_options" {

  domain_name = "${aws_route53_zone.mm_devpaas_dns_primary_fw.name}"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name = "${var.project_name}-DHCP-OPTIONS"
  }
}


resource "aws_vpc_dhcp_options_association" "mm_devpaas_vpc_dhcp_options_association" {

  dhcp_options_id = "${aws_vpc_dhcp_options.mm_devpaas_vpc_dhcp_options.id}"
  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

}