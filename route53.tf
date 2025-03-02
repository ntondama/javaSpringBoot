# ✅ Create Private Hosted Zone
resource "aws_route53_zone" "private_zone" {
  name = "dvstech.com"
  vpc {
    vpc_id = aws_vpc.main.id
  }
}

# ✅ Create DNS Records for EC2 Instances
resource "aws_route53_record" "dns_records" {
  count   = 3
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "server${count.index + 1}.dvstech.com"
  type    = "A"
  ttl     = 300
  records = [aws_instance.servers[count.index].private_ip]
}
