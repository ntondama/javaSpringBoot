output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
}

output "server_ips" {
  value = [for instance in aws_instance.servers : instance.public_ip]
}

output "dns_records" {
  value = [for record in aws_route53_record.dns_records : record.fqdn]
}
