# --------------------------------------------------------------------------------------
#              EIP Definition
# --------------------------------------------------------------------------------------

resource "aws_eip" "mm_devpaas_nat_eip" {
  vpc = true
}

resource "aws_eip" "mm_devpaas_admin_eip" {
  vpc = true
}

# --------------------------------------------------------------------------------------
#              VPC Definition
# --------------------------------------------------------------------------------------

resource "aws_vpc" "mm_devpaas_vpc" {

  cidr_block = "${var.vpc_cidr}"

  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags {
    Name = "MM-DEVPAAS-VPC"
  }
}

# --------------------------------------------------------------------------------------
#              INTERNET GATEWAY (IGW) Definition
# --------------------------------------------------------------------------------------

resource "aws_internet_gateway" "mm_devpaas_igw" {

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "MM-DEVPAAS-IGW"
  }
}

# --------------------------------------------------------------------------------------
#              SUBNETs
# --------------------------------------------------------------------------------------

# SUBNET Definition for Public addresses
resource "aws_subnet" "mm_devpaas_sb_public" {

  vpc_id                  = "${aws_vpc.mm_devpaas_vpc.id}"
  cidr_block              = "${var.subnet_public_cidr}"
  availability_zone       = "${var.aws_deployment_region}a"
  map_public_ip_on_launch = true

  tags {
    Name = "MM-DEVPAAS-SB-PUBLIC"
  }
}

# SUBNET Definition for Private addresses
resource "aws_subnet" "mm_devpaas_sb_private" {
  vpc_id            = "${aws_vpc.mm_devpaas_vpc.id}"
  cidr_block        = "${var.subnet_private_cidr}"
  availability_zone = "${var.aws_deployment_region}a"

  tags {
    Name = "MM-DEVPAAS-SB-PRIVATE"
  }
}


# --------------------------------------------------------------------------------------
#              NAT GATEWAY
# --------------------------------------------------------------------------------------

# NAT Gateway
resource "aws_nat_gateway" "mm_devpaas_natgw" {
  allocation_id = "${aws_eip.mm_devpaas_nat_eip.id}"
  subnet_id     = "${aws_subnet.mm_devpaas_sb_public.id}"

  depends_on = ["aws_internet_gateway.mm_devpaas_igw"]
}

# --------------------------------------------------------------------------------------
#              ROUTING TABLES & ROUTES
# --------------------------------------------------------------------------------------

# RouteTable Public
resource "aws_route_table" "mm_devpaas_rt_public" {

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "MM-DEVPAAS-RT-Public"
  }
}

# Route to IGW Gateway
resource "aws_route" "mm_devpaas_route_public" {

  route_table_id          = "${aws_route_table.mm_devpaas_rt_public.id}"
  gateway_id              = "${aws_internet_gateway.mm_devpaas_igw.id}"
  destination_cidr_block  = "0.0.0.0/0"

}

# Route Table association: Route Table Public <--> Public Subnet
resource "aws_route_table_association" "mm_devpaas_rta_sbpublic" {

  route_table_id  = "${aws_route_table.mm_devpaas_rt_public.id}"
  subnet_id       = "${aws_subnet.mm_devpaas_sb_public.id}"

}


# RouteTable Private
resource "aws_route_table" "mm_devpaas_rt_private" {

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "MM-DEVPAAS-RT-Private"
  }
}

# Route to the NAT Gateway
resource "aws_route" "mm_devpaas_route_private" {
  route_table_id          = "${aws_route_table.mm_devpaas_rt_private.id}"
  gateway_id              = "${aws_nat_gateway.mm_devpaas_natgw.id}"
  destination_cidr_block  = "0.0.0.0/0"
}

# Route Table association: Route Table Private <--> Private Subnet
resource "aws_route_table_association" "mm_devpaas_rta_sbprivate" {

  route_table_id  = "${aws_route_table.mm_devpaas_rt_private.id}"
  subnet_id       = "${aws_subnet.mm_devpaas_sb_private.id}"

}