###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
### Networking - LAN
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
resource "aws_vpc" "vpc" {
  cidr_block           = var.network
  enable_dns_hostnames = var.dnshostname
  tags                 = local.tags
}
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.tags
}
resource "aws_subnet" "subnets" {
  count                   = var.subnets_count
  cidr_block              = cidrsubnet(var.network, 8, count.index)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.mapip
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags                    = local.tags
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
### Networking - Routing
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
resource "aws_route_table" "rtable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
  tags = local.tags
}
resource "aws_route_table_association" "rta-subnets" {
  count          = var.subnets_count
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rtable.id
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
### Networking - Security Groups
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
resource "aws_security_group" "lb_nsg" {
  name   = "lb-nsg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}
resource "aws_security_group" "server-nsg" {
  name   = "server-nsg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.network]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
### Networking - Load Balancing
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
resource "aws_lb" "primary-lb" {
  name                       = "lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb_nsg.id]
  subnets                    = aws_subnet.subnets[*].id
  enable_deletion_protection = false
  tags                       = local.tags
}
resource "aws_lb_target_group" "webserver_target" {
  name     = "lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}
resource "aws_lb_listener" "webserver_listener" {
  load_balancer_arn = aws_lb.primary-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_target.arn
  }
  tags = local.tags
}
resource "aws_lb_target_group_attachment" "webserver_target_attach" {
  count            = var.resource_count
  target_group_arn = aws_lb_target_group.webserver_target.arn
  target_id        = aws_instance.webserver[count.index].id
  port             = 80
}