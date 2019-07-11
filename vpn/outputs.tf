output "ip" {
  value = aws_instance.vpn_instance.public_ip
}

output "dns" {
  value = aws_instance.vpn_instance.public_dns
}