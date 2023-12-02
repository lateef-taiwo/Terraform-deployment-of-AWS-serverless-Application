resource "aws_route53_zone" "my_domain_zone" {
  name = var.domain_name  
  comment = "My Route53 Hosted Zone"
}

output "name_servers" {
  value = aws_route53_zone.my_domain_zone.name_servers
}