# --------------------------------------------------------------------------------------
#              ROUTE TABLES DEFINTIONS
# --------------------------------------------------------------------------------------

# RouteTable Public
resource "aws_route_table" "mm_devpaas_rt_public" {

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "MM-DEVPAAS-RT-Public"
  }
}

# RouteTable Private
resource "aws_route_table" "mm_devpaas_rt_private" {

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "MM-DEVPAAS-RT-Private"
  }
}

# --------------------------------------------------------------------------------------
#              ROUTES for Public Subnet via Internet Gateway
# --------------------------------------------------------------------------------------

# Route to IGW Gateway for Public Subnet
resource "aws_route" "mm_devpaas_route_public" {

  route_table_id          = "${aws_route_table.mm_devpaas_rt_public.id}"
  gateway_id              = "${aws_internet_gateway.mm_devpaas_igw.id}"
  destination_cidr_block  = "0.0.0.0/0"

}

# --------------------------------------------------------------------------------------
#              ROUTES for Private Subnet via NAT Gateway
# --------------------------------------------------------------------------------------

# Route to the NAT Gateway
resource "aws_route" "mm_devpaas_route_private" {
  route_table_id          = "${aws_route_table.mm_devpaas_rt_private.id}"
  nat_gateway_id          = "${aws_nat_gateway.mm_devpaas_natgw.id}"
  destination_cidr_block  = "0.0.0.0/0"
}

# --------------------------------------------------------------------------------------
#              ROUTE TABLE <--> Subnet Association
# --------------------------------------------------------------------------------------

# Route Table association: Route Table Public <--> Public Subnet
resource "aws_route_table_association" "mm_devpaas_rta_sbpublic" {

  route_table_id  = "${aws_route_table.mm_devpaas_rt_public.id}"
  subnet_id       = "${aws_subnet.mm_devpaas_sb_public.id}"

}

# Route Table association: Route Table Private <--> Private Subnet
resource "aws_route_table_association" "mm_devpaas_rta_sbprivate" {

  route_table_id  = "${aws_route_table.mm_devpaas_rt_private.id}"
  subnet_id       = "${aws_subnet.mm_devpaas_sb_private.id}"

}