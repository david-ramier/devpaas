/*
 *  List of instances
 */

/* ********************************************************************** */
/* JUMP BOX VM DEFINITION                                                 */
/* ********************************************************************** */
resource "aws_instance" "mm_devpaas_dv_jumpbox" {

  ami                     = "${var.jumpbox_image_id}"
  instance_type           = "${var.jumpbox_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_public.id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_jb.id}"]  // ["${var.sg_jumpbox_id}"]

  /*
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World ! This is the DevPaas Jump Box VM" > index.html
              nohup busybox httpd -f -p 80 &
              EOF
  */

  user_data = <<-EOF
            #!/bin/bash
            export domain=${var.primary_zone_domain_name}
            export vm_name=${var.jumpbox_instance_name}

            echo "Changing the search domain in /etc/resolv.conf file"
            /bin/sed -i "s/search.*/search $domain/g" /etc/resolv.conf

            echo "Changing the hostname in /etc/hosts file ..."
            /bin/sed -i "s/localhost/$vm_name/g" /etc/hosts

            echo "Retrieving the current hostname ..."
            export aws_hostname=`/bin/hostname`

            echo "Changing the aws hostname ($aws_hostname) with target hostname ($vm_name) in /etc/hostname file ..."
            /bin/sed -i "s/$aws_hostname/$vm_name/g" /etc/hostname

            /bin/hostname $vm_name
            EOF

  tags {
    Name = "${var.jumpbox_instance_name}"
  }

}

resource "aws_eip_association" "mm_devpaas_eip_jb_assoc" {

  instance_id   = "${aws_instance.mm_devpaas_dv_jumpbox.id}"
  allocation_id = "${aws_eip.mm_devpaas_admin_eip.id}"                      //"${var.mm_devpaas_eip_id}"

}

resource "aws_route53_record" "mm_devpaas_dns_r_jb" {

  zone_id = "${aws_route53_zone.mm_devpaas_dns_primary_fw.id}"
  type    = "A"
  name    = "${var.jumpbox_instance_name}"
  records = ["${aws_instance.mm_devpaas_dv_jumpbox.private_ip}"]
  ttl     = "300"

}

resource "aws_route53_record" "mm_devpaas_dns_r_jb_reverse" {

  zone_id = "${aws_route53_zone.mm_devpaas_dns_primary_rv.id}"
  type    = "PTR"
  name    = "${format("%s.%s.0.10.in-addr.arpa",
                  element(split(".",aws_instance.mm_devpaas_dv_jumpbox.private_ip),3),
                  element(split(".",aws_instance.mm_devpaas_dv_jumpbox.private_ip),2))}"
  records = ["${format("mm-devpaas-jb.marmac-labs.name")}"]

  ttl     = "300"


}