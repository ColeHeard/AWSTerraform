###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
### Resources - Modules - S3 bucket
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
module "s3-bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "3.4.0"
  bucket_prefix = "${var.prefix}s3files"
  acl           = "private"
  tags          = local.tags
}
resource "aws_s3_object" "webserver_files" {
  for_each = {
    html   = "/files/index.html"
    resume = "/files/image.png"
  }
  bucket = module.s3-bucket.s3_bucket_id
  key    = each.value
  source = ".${each.value}"
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
### Resources - Instance - NGINX Webservers
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
resource "aws_instance" "webserver" {
  count                  = var.resource_count
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.inst_size[1]
  subnet_id              = aws_subnet.subnets[count.index % var.subnets_count].id
  vpc_security_group_ids = [aws_security_group.server-nsg.id]
  iam_instance_profile   = aws_iam_instance_profile.web_instance_profile.id
  tags                   = local.tags
  user_data = templatefile("${path.module}/files/prep.sh", {
    remoteshare = module.s3-bucket.s3_bucket_id
  })
}
